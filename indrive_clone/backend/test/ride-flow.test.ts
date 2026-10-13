/**
 * End-to-end test of the full InDrive flow:
 * login -> driver sign-up -> online -> request -> offer -> accept -> live tracking -> chat -> arrive -> start -> complete -> rating.
 *
 * Needs PostgreSQL (with PostGIS) and Redis running. Run: npm test
 */
import type { AddressInfo } from 'node:net';
import { createServer, type Server as HttpServer } from 'node:http';
import pg from 'pg';
import { io as ioClient, type Socket } from 'socket.io-client';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

const BASE_DB = process.env.TEST_DATABASE_URL ?? 'postgres://postgres:postgres@localhost:5432/indrive_test';
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = BASE_DB;
process.env.REDIS_URL = process.env.TEST_REDIS_URL ?? 'redis://localhost:6379/1';
process.env.EXPAND_EVERY_SEC = '2'; // grow the search circle fast in tests
process.env.OFFER_TTL_SEC = '30';
process.env.AUTO_APPROVE_DRIVERS = 'true';
process.env.DEV_OTP = 'true';
// Do not call real map services in tests (straight-line estimate is used when they fail).
process.env.OSRM_URL = 'http://127.0.0.1:9';
process.env.NOMINATIM_URL = 'http://127.0.0.1:9';

// Lahore: Liberty Market -> Gulberg / DHA
const PICKUP = { lat: 31.5104, lng: 74.3416, address: 'Liberty Market, Lahore' };
const DROPOFF = { lat: 31.4697, lng: 74.4089, address: 'DHA Phase 5, Lahore' };
const NEAR_DRIVER = { lat: 31.5185, lng: 74.3440 }; // ~0.9 km from pickup
const FAR_DRIVER = { lat: 31.5500, lng: 74.3416 }; // ~4.4 km from pickup (outside first 3 km circle)

let http: HttpServer;
let base: string;
let stop: () => Promise<void>;
const sockets: Socket[] = [];

async function api<T = any>(method: string, path: string, token?: string, body?: unknown): Promise<{ status: number; data: T }> {
  const res = await fetch(`${base}/api/v1${path}`, {
    method,
    headers: { 'content-type': 'application/json', ...(token ? { authorization: `Bearer ${token}` } : {}) },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  return { status: res.status, data: (await res.json()) as T };
}

async function login(phone: string, name: string) {
  const otp = await api('POST', '/auth/otp/request', undefined, { phone });
  expect(otp.status).toBe(200);
  const v = await api('POST', '/auth/otp/verify', undefined, { phone, code: otp.data.devCode });
  expect(v.status).toBe(200);
  await api('PATCH', '/users/me', v.data.accessToken, { name });
  return v.data as { accessToken: string; refreshToken: string; userId: string };
}

async function registerDriver(token: string, plate: string, cnic: string) {
  const form = new FormData();
  form.set('cnicNumber', cnic);
  form.set('licenseNumber', 'LHR-12345');
  form.set('vehicleType', 'mini');
  form.set('vehicleMake', 'Suzuki');
  form.set('vehicleModel', 'Alto');
  form.set('vehicleColor', 'White');
  form.set('vehicleYear', '2020');
  form.set('plateNumber', plate);
  form.set('services', 'city,courier');
  const res = await fetch(`${base}/api/v1/drivers/register`, { method: 'POST', headers: { authorization: `Bearer ${token}` }, body: form });
  return { status: res.status, data: (await res.json()) as any };
}

function connect(token: string): Promise<Socket> {
  return new Promise((resolve, reject) => {
    const s = ioClient(base, { auth: { token }, transports: ['websocket'], forceNew: true });
    sockets.push(s);
    s.on('connect', () => resolve(s));
    s.on('connect_error', reject);
  });
}

function waitFor<T = any>(s: Socket, event: string, timeoutMs = 8000, filter: (d: T) => boolean = () => true): Promise<T> {
  return new Promise((resolve, reject) => {
    const t = setTimeout(() => reject(new Error(`timeout waiting for ${event}`)), timeoutMs);
    const h = (d: T) => {
      if (!filter(d)) return;
      clearTimeout(t);
      s.off(event, h);
      resolve(d);
    };
    s.on(event, h);
  });
}

beforeAll(async () => {
  // Fresh test database
  const admin = new pg.Client({ connectionString: BASE_DB.replace(/\/[^/]+$/, '/postgres') });
  await admin.connect();
  await admin.query('DROP DATABASE IF EXISTS indrive_test WITH (FORCE)');
  await admin.query('CREATE DATABASE indrive_test');
  await admin.end();

  const { redis } = await import('../src/lib/redis.js');
  await redis.flushdb();
  const { runMigrations } = await import('../src/db/migrate.js');
  await runMigrations();

  const { createApp } = await import('../src/app.js');
  const { createSocketServer } = await import('../src/realtime/socket.js');
  const { startWorker, closeQueue } = await import('../src/jobs/queue.js');
  const { handleJob } = await import('../src/modules/rides/matching.service.js');
  const { pool } = await import('../src/db/client.js');

  http = createServer(createApp());
  const io = createSocketServer(http);
  const worker = startWorker(handleJob);
  await new Promise<void>((r) => http.listen(0, '127.0.0.1', r));
  base = `http://127.0.0.1:${(http.address() as AddressInfo).port}`;

  stop = async () => {
    sockets.forEach((s) => s.disconnect());
    await io.close();
    await worker.close();
    await closeQueue();
    await pool.end();
    redis.disconnect();
  };
});

afterAll(async () => {
  await stop?.();
});

describe('InDrive ride flow', () => {
  let passenger: Awaited<ReturnType<typeof login>>;
  let driver: Awaited<ReturnType<typeof login>>;
  let farDriver: Awaited<ReturnType<typeof login>>;
  let pSock: Socket;
  let dSock: Socket;
  let fSock: Socket;
  let rideId: string;
  let offerId: string;

  it('rejects bad phone numbers and wrong OTP', async () => {
    expect((await api('POST', '/auth/otp/request', undefined, { phone: '12345' })).status).toBe(400);
    await api('POST', '/auth/otp/request', undefined, { phone: '03119998887' });
    const wrong = await api('POST', '/auth/otp/verify', undefined, { phone: '03119998887', code: '0000' });
    // 1 in 10,000 chance the random code is 0000
    expect([200, 400]).toContain(wrong.status);
  });

  it('logs in passenger and drivers with phone + OTP', async () => {
    passenger = await login('03001111111', 'Ali Passenger');
    driver = await login('03002222222', 'Bilal Driver');
    farDriver = await login('03003333333', 'Usman Far');
    const me = await api('GET', '/users/me', passenger.accessToken);
    expect(me.data.user.phone).toBe('+923001111111');
    expect(me.data.user.name).toBe('Ali Passenger');
  });

  it('refresh token rotation works', async () => {
    const r = await api('POST', '/auth/refresh', undefined, { refreshToken: passenger.refreshToken });
    expect(r.status).toBe(200);
    const again = await api('POST', '/auth/refresh', undefined, { refreshToken: passenger.refreshToken });
    expect(again.status).toBe(401); // old token cannot be used twice
    passenger.accessToken = r.data.accessToken;
  });

  it('registers drivers (auto approved) with welcome bonus', async () => {
    const r = await registerDriver(driver.accessToken, 'LEA 1234', '35202-1234567-1');
    expect(r.status).toBe(201);
    expect(r.data.status).toBe('approved');
    expect(r.data.balance).toBe(500);
    expect(r.data.vehicle.plateNumber).toBe('LEA-1234');
    const dup = await registerDriver(farDriver.accessToken, 'LEA 1234', '35202-7654321-1');
    expect(dup.status).toBe(409);
    expect((await registerDriver(farDriver.accessToken, 'LEB 999', '35202-7654321-1')).status).toBe(201);
  });

  it('drivers go online and appear on the passenger map', async () => {
    pSock = await connect(passenger.accessToken);
    dSock = await connect(driver.accessToken);
    fSock = await connect(farDriver.accessToken);
    expect((await api('POST', '/drivers/me/online', driver.accessToken, { online: true, ...NEAR_DRIVER })).status).toBe(200);
    expect((await api('POST', '/drivers/me/online', farDriver.accessToken, { online: true, ...FAR_DRIVER })).status).toBe(200);
    const near = await api('GET', `/drivers/nearby?lat=${PICKUP.lat}&lng=${PICKUP.lng}`, passenger.accessToken);
    expect(near.data.drivers.length).toBe(2);
    expect(near.data.drivers[0].distanceM).toBeLessThan(1000);
  });

  it('estimates fares for every vehicle', async () => {
    const e = await api('POST', '/rides/estimate', passenger.accessToken, { serviceType: 'city', pickup: PICKUP, dropoff: DROPOFF });
    expect(e.status).toBe(200);
    expect(e.data.options.map((o: any) => o.vehicleType)).toEqual(['moto', 'rickshaw', 'mini', 'ac', 'comfort']);
    const mini = e.data.options.find((o: any) => o.vehicleType === 'mini');
    expect(mini.recommendedFare).toBeGreaterThanOrEqual(mini.minFare);
  });

  it('rejects a fare below the minimum', async () => {
    const r = await api('POST', '/rides', passenger.accessToken, { vehicleType: 'mini', pickup: PICKUP, dropoff: DROPOFF, offeredFare: 50 });
    expect(r.status).toBe(400);
    expect(r.data.error.code).toBe('fare_too_low');
  });

  it('sends the request only to drivers inside 3 km, then grows the circle', async () => {
    const nearGot = waitFor(dSock, 'ride:request');
    const farGot = waitFor(fSock, 'ride:request', 10_000);
    const est = await api('POST', '/rides/estimate', passenger.accessToken, { pickup: PICKUP, dropoff: DROPOFF });
    const fare = est.data.options.find((o: any) => o.vehicleType === 'mini').recommendedFare;

    const created = await api('POST', '/rides', passenger.accessToken, {
      serviceType: 'city',
      vehicleType: 'mini',
      pickup: PICKUP,
      dropoff: DROPOFF,
      offeredFare: fare,
      comment: 'Near the main gate',
    });
    expect(created.status).toBe(201);
    expect(created.data.status).toBe('searching');
    expect(created.data.searchRadiusM).toBe(3000);
    rideId = created.data.id;

    const req = await nearGot;
    expect(req.rideId).toBe(rideId);
    expect(req.pickupDistanceM).toBeLessThan(1500);
    expect(req.passenger.name).toBe('Ali Passenger');
    expect(req.passenger.phone).toBeUndefined(); // private until matched

    // Far driver gets it only after the circle grows to 5 km (EXPAND_EVERY_SEC=2 in tests)
    const farReq = await farGot;
    expect(farReq.rideId).toBe(rideId);
    const ride = await api('GET', `/rides/${rideId}`, passenger.accessToken);
    expect(ride.data.searchRadiusM).toBeGreaterThanOrEqual(5000);

    // A second active ride is not allowed
    const second = await api('POST', '/rides', passenger.accessToken, { vehicleType: 'mini', pickup: PICKUP, dropoff: DROPOFF, offeredFare: fare });
    expect(second.status).toBe(409);
  });

  it('driver feed lists the open request', async () => {
    const feed = await api('GET', '/drivers/me/requests', driver.accessToken);
    expect(feed.data.map((r: any) => r.rideId)).toContain(rideId);
  });

  it('passenger raises the fare and drivers see the new price', async () => {
    const ride = await api('GET', `/rides/${rideId}`, passenger.accessToken);
    const got = waitFor(dSock, 'ride:request_updated');
    const r = await api('PATCH', `/rides/${rideId}/fare`, passenger.accessToken, { offeredFare: ride.data.offeredFare + 50 });
    expect(r.status).toBe(200);
    expect((await got).offeredFare).toBe(ride.data.offeredFare + 50);
  });

  it('drivers send offers (accept price or counter-offer) and passenger sees them', async () => {
    const ride = (await api('GET', `/rides/${rideId}`, passenger.accessToken)).data;
    const low = await api('POST', `/rides/${rideId}/offers`, driver.accessToken, { price: ride.offeredFare - 10 });
    expect(low.status).toBe(400); // cannot offer less than passenger price

    const gotOffer = waitFor(pSock, 'offer:new', 8000, (o: any) => o.driver.name === 'Bilal Driver');
    const o = await api('POST', `/rides/${rideId}/offers`, driver.accessToken, { price: ride.offeredFare + 30 });
    expect(o.status).toBe(201);
    const seen = await gotOffer;
    expect(seen.price).toBe(ride.offeredFare + 30);
    expect(seen.driver.vehicle.plateNumber).toBe('LEA-1234');
    expect(seen.etaSec).toBeGreaterThan(0);
    offerId = seen.id;

    const farOffer = await api('POST', `/rides/${rideId}/offers`, farDriver.accessToken, { price: ride.offeredFare });
    expect(farOffer.status).toBe(201);
    const full = await api('GET', `/rides/${rideId}`, passenger.accessToken);
    expect(full.data.offers.length).toBe(2);
  });

  it('passenger accepts one offer; other driver is told the request is closed', async () => {
    const driverGot = waitFor(dSock, 'ride:updated', 8000, (r: any) => r.status === 'accepted');
    const farClosed = waitFor(fSock, 'ride:request_closed');
    const r = await api('POST', `/rides/${rideId}/offers/${offerId}/accept`, passenger.accessToken);
    expect(r.status).toBe(200);
    expect(r.data.status).toBe('accepted');
    expect(r.data.driver.name).toBe('Bilal Driver');
    expect(r.data.driver.phone).toBe('+923002222222'); // phones shared after match
    const d = await driverGot;
    expect(d.passenger.phone).toBe('+923001111111');
    expect((await farClosed).reason).toBe('taken');

    // Accepting twice must fail
    expect((await api('POST', `/rides/${rideId}/offers/${offerId}/accept`, passenger.accessToken)).status).toBe(409);
  });

  it('live tracking: passenger sees driver coming, driver sees passenger', async () => {
    const pGot = waitFor(pSock, 'driver:location');
    dSock.emit('driver:location', { lat: 31.514, lng: 74.343, heading: 180, speed: 8 });
    const loc = await pGot;
    expect(loc.rideId).toBe(rideId);
    expect(loc.distanceM).toBeLessThan(600);
    expect(loc.etaSec).toBeGreaterThan(0);

    const dGot = waitFor(dSock, 'passenger:location');
    pSock.emit('passenger:location', { lat: 31.5106, lng: 74.3417 });
    const ploc = await dGot;
    expect(ploc.distanceToPickupM).toBeLessThan(50);
  });

  it('chat between passenger and driver', async () => {
    const got = waitFor(dSock, 'chat:message');
    await api('POST', `/rides/${rideId}/messages`, passenger.accessToken, { body: 'I am wearing a blue shirt' });
    expect((await got).body).toBe('I am wearing a blue shirt');
    const list = await api('GET', `/rides/${rideId}/messages`, driver.accessToken);
    expect(list.data.length).toBe(1);
  });

  it('arrived -> start -> complete, commission taken from driver balance', async () => {
    const arrived = waitFor(pSock, 'ride:updated', 8000, (r: any) => r.status === 'arrived');
    expect((await api('POST', `/rides/${rideId}/arrived`, driver.accessToken)).status).toBe(200);
    await arrived;
    expect((await api('POST', `/rides/${rideId}/start`, passenger.accessToken)).status).toBe(403); // only driver
    expect((await api('POST', `/rides/${rideId}/start`, driver.accessToken)).data.status).toBe('in_progress');
    const done = await api('POST', `/rides/${rideId}/complete`, driver.accessToken);
    expect(done.data.status).toBe('completed');
    const fare = done.data.finalFare;
    const earn = await api('GET', '/drivers/me/earnings', driver.accessToken);
    expect(earn.data.balance).toBe(500 - Math.round(fare * 0.1));
    expect(earn.data.today.rides).toBe(1);
    expect(earn.data.today.gross).toBe(fare);
  });

  it('both sides rate each other', async () => {
    expect((await api('POST', `/rides/${rideId}/rate`, passenger.accessToken, { stars: 4, review: 'Good' })).status).toBe(200);
    expect((await api('POST', `/rides/${rideId}/rate`, passenger.accessToken, { stars: 5 })).status).toBe(409);
    expect((await api('POST', `/rides/${rideId}/rate`, driver.accessToken, { stars: 5 })).status).toBe(200);
    const d = await api('GET', '/drivers/me', driver.accessToken);
    expect(d.data.ratingCount).toBe(1);
    expect(d.data.rating).toBe(4);
  });

  it('history and recent places', async () => {
    const h = await api('GET', '/rides/history?role=passenger', passenger.accessToken);
    expect(h.data[0].id).toBe(rideId);
    const hd = await api('GET', '/rides/history?role=driver', driver.accessToken);
    expect(hd.data[0].id).toBe(rideId);
    const recent = await api('GET', '/rides/recent-places', passenger.accessToken);
    expect(recent.data[0].address).toBe(DROPOFF.address);
    expect((await api('GET', '/rides/active', passenger.accessToken)).data.ride).toBeNull();
  });

  it('passenger can cancel a searching ride and drivers are told', async () => {
    const closed = waitFor(dSock, 'ride:request_closed', 8000, (x: any) => x.reason === 'cancelled');
    const c = await api('POST', '/rides', passenger.accessToken, { vehicleType: 'mini', pickup: PICKUP, dropoff: DROPOFF, offeredFare: 2000 });
    expect(c.status).toBe(201);
    const r = await api('POST', `/rides/${c.data.id}/cancel`, passenger.accessToken, { reason: 'Changed my plans' });
    expect(r.data.status).toBe('cancelled');
    expect(r.data.cancelledBy).toBe('passenger');
    await closed;
  });

  it('an offer from a driver who went offline cannot be accepted', async () => {
    const c = await api('POST', '/rides', passenger.accessToken, { vehicleType: 'mini', pickup: PICKUP, dropoff: DROPOFF, offeredFare: 2000 });
    expect(c.status).toBe(201);
    const o = await api('POST', `/rides/${c.data.id}/offers`, farDriver.accessToken, { price: 2000 });
    expect(o.status).toBe(201);
    await api('POST', '/drivers/me/online', farDriver.accessToken, { online: false });
    const acc = await api('POST', `/rides/${c.data.id}/offers/${o.data.id}/accept`, passenger.accessToken);
    expect(acc.status).toBe(409);
    expect(acc.data.error.code).toBe('driver_unavailable');
    await api('POST', `/rides/${c.data.id}/cancel`, passenger.accessToken, { reason: 'Test done' });
    await api('POST', '/drivers/me/online', farDriver.accessToken, { online: true, ...FAR_DRIVER });
  });

  it('support ticket: user reports a lost item, admin replies', async () => {
    const t = await api('POST', '/support/tickets', passenger.accessToken, { category: 'lost_item', rideId, message: 'I left my black bag in the back seat' });
    expect(t.status).toBe(201);
    const other = await api('POST', '/support/tickets', farDriver.accessToken, { category: 'lost_item', rideId, message: 'Trying to use a ride that is not mine' });
    expect(other.status).toBe(403);
    const res = await fetch(`${base}/api/v1/admin/tickets/${t.data.id}/reply`, {
      method: 'POST',
      headers: { 'content-type': 'application/json', 'x-admin-key': 'admin123' },
      body: JSON.stringify({ reply: 'We contacted the driver, he has your bag.' }),
    });
    expect(res.status).toBe(200);
    const list = await api('GET', '/support/tickets', passenger.accessToken);
    expect(list.data[0].status).toBe('answered');
    expect(list.data[0].adminReply).toContain('bag');
  });

  it('share trip link works without login, only with the right signature', async () => {
    const link = await api('GET', `/rides/${rideId}/share-link`, passenger.accessToken);
    expect(link.status).toBe(200);
    const [, , id, sig] = new URL(link.data.url).pathname.split('/'); // /t/<id>/<sig>
    const ok = await fetch(`${base}/api/v1/share/${id}/${sig}`);
    expect(ok.status).toBe(200);
    const data = (await ok.json()) as any;
    expect(data.status).toBe('completed');
    expect(data.driver.plateNumber).toBe('LEA-1234');
    expect((await fetch(`${base}/api/v1/share/${id}/wrongsignature`)).status).toBe(404);
    expect((await fetch(`${base}/t/${id}/${sig}`)).status).toBe(200); // web page
  });

  it('admin can block a user (logged out, cannot log in again)', async () => {
    const u = await login('03004444444', 'Bad User');
    const block = await fetch(`${base}/api/v1/admin/users/${u.userId}/block`, { method: 'POST', headers: { 'x-admin-key': 'admin123' } });
    expect(block.status).toBe(200);
    expect((await api('POST', '/auth/refresh', undefined, { refreshToken: u.refreshToken })).status).toBe(401);
    const otp = await api('POST', '/auth/otp/request', undefined, { phone: '03004444444' });
    const v = await api('POST', '/auth/otp/verify', undefined, { phone: '03004444444', code: otp.data.devCode });
    expect(v.status).toBe(403);
  });

  it('app config has version and legal links', async () => {
    const c = (await (await fetch(`${base}/api/v1/config`)).json()) as any;
    expect(c.minAppVersion).toBeTruthy();
    expect(c.legal.termsUrl).toContain('/legal/terms');
    expect((await fetch(`${base}/legal/privacy`)).status).toBe(200);
  });

  it('driver can go offline', async () => {
    expect((await api('POST', '/drivers/me/online', driver.accessToken, { online: false })).status).toBe(200);
    const near = await api('GET', `/drivers/nearby?lat=${PICKUP.lat}&lng=${PICKUP.lng}`, passenger.accessToken);
    expect(near.data.drivers.length).toBe(1);
  });
});

/**
 * DRIVER SIMULATOR
 * ----------------
 * Creates fake drivers that behave like real InDrive drivers, so you can test the passenger app alone:
 *   - they go online around a city and move a little,
 *   - they receive your request and send offers (some accept your price, some ask for more),
 *   - when you accept one, it drives along the real road to you, arrives, starts and finishes the trip.
 *
 * Usage (server must be running, DEV_OTP=true):
 *   npm run simulate                       -> 8 drivers in Lahore
 *   npm run simulate -- --city karachi --count 15
 *   npm run simulate -- --lat 33.6844 --lng 73.0479   (any place)
 */
import { io, type Socket } from 'socket.io-client';
import { bearing, decodePolyline, distanceM, type LatLng } from '../src/lib/geo.js';

const args = Object.fromEntries(
  process.argv.slice(2).reduce<[string, string][]>((acc, a, i, all) => {
    if (a.startsWith('--')) acc.push([a.slice(2), all[i + 1] ?? '']);
    return acc;
  }, []),
);

const CITIES: Record<string, LatLng> = {
  lahore: { lat: 31.5204, lng: 74.3587 },
  karachi: { lat: 24.8607, lng: 67.0011 },
  islamabad: { lat: 33.6844, lng: 73.0479 },
  rawalpindi: { lat: 33.5651, lng: 73.0169 },
  faisalabad: { lat: 31.4504, lng: 73.135 },
  multan: { lat: 30.1575, lng: 71.5249 },
  peshawar: { lat: 34.0151, lng: 71.5249 },
};

const SERVER = args.server ?? process.env.SIM_SERVER ?? 'http://localhost:4000';
const COUNT = Number(args.count ?? 8);
const CENTER: LatLng =
  args.lat && args.lng ? { lat: Number(args.lat), lng: Number(args.lng) } : (CITIES[(args.city ?? 'lahore').toLowerCase()] ?? CITIES.lahore!);
const SPREAD_M = Number(args.spread ?? 2500);
const SPEED_MPS = Number(args.speed ?? 12); // ~43 km/h (simulation is a bit faster than real life)

const NAMES = ['Ahmed Raza', 'Bilal Khan', 'Usman Tariq', 'Hamza Ali', 'Imran Shah', 'Zeeshan Akhtar', 'Kamran Iqbal', 'Faisal Mehmood', 'Asad Butt', 'Waqas Hussain', 'Naveed Anjum', 'Shahid Latif', 'Adnan Javed', 'Junaid Aslam', 'Saad Qureshi'];
const VEHICLES = [
  { vehicleType: 'mini', make: 'Suzuki', model: 'Alto', color: 'White', services: 'city,courier,intercity' },
  { vehicleType: 'ac', make: 'Toyota', model: 'Corolla', color: 'Silver', services: 'city,intercity' },
  { vehicleType: 'moto', make: 'Honda', model: 'CD 70', color: 'Red', services: 'city,courier' },
  { vehicleType: 'rickshaw', make: 'Sazgar', model: 'Auto', color: 'Green', services: 'city' },
  { vehicleType: 'mini', make: 'Suzuki', model: 'Cultus', color: 'Grey', services: 'city,courier' },
  { vehicleType: 'comfort', make: 'Honda', model: 'Civic', color: 'Black', services: 'city,intercity' },
  { vehicleType: 'ac', make: 'Toyota', model: 'Yaris', color: 'White', services: 'city' },
  { vehicleType: 'moto', make: 'Yamaha', model: 'YBR', color: 'Blue', services: 'city,courier' },
  { vehicleType: 'loader', make: 'Suzuki', model: 'Ravi', color: 'White', services: 'freight' },
  { vehicleType: 'mini', make: 'Suzuki', model: 'WagonR', color: 'Blue', services: 'city,courier' },
] as const;

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));
const rand = (a: number, b: number) => a + Math.random() * (b - a);

function randomPointNear(c: LatLng, radiusM: number): LatLng {
  const r = radiusM * Math.sqrt(Math.random());
  const t = Math.random() * 2 * Math.PI;
  return { lat: c.lat + (r * Math.cos(t)) / 111_320, lng: c.lng + (r * Math.sin(t)) / (111_320 * Math.cos((c.lat * Math.PI) / 180)) };
}

class SimDriver {
  token = '';
  userId = '';
  refreshToken = '';
  socket!: Socket;
  pos: LatLng;
  heading = 0;
  busyRideId: string | null = null;
  driving = false;
  name: string;
  vehicle: (typeof VEHICLES)[number];

  constructor(public index: number) {
    this.pos = randomPointNear(CENTER, SPREAD_M);
    this.name = NAMES[index % NAMES.length]!;
    this.vehicle = VEHICLES[index % VEHICLES.length]!;
  }

  get phone() {
    return `0399${String(1000000 + this.index).slice(-7)}`;
  }

  log(msg: string) {
    console.log(`[${this.name.padEnd(15)} ${this.vehicle.vehicleType.padEnd(8)}] ${msg}`);
  }

  async api<T = any>(method: string, path: string, body?: unknown, form?: FormData): Promise<T> {
    const res = await fetch(`${SERVER}/api/v1${path}`, {
      method,
      headers: { ...(form ? {} : { 'content-type': 'application/json' }), ...(this.token ? { authorization: `Bearer ${this.token}` } : {}) },
      body: form ?? (body === undefined ? undefined : JSON.stringify(body)),
    });
    const json = (await res.json()) as any;
    if (res.status === 401 && json?.error?.code === 'token_expired' && this.refreshToken) {
      await this.refresh();
      return this.api(method, path, body, form);
    }
    if (!res.ok) throw new Error(json?.error?.message ?? res.statusText);
    return json as T;
  }

  async refresh() {
    const r = await fetch(`${SERVER}/api/v1/auth/refresh`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ refreshToken: this.refreshToken }),
    }).then((x) => x.json() as Promise<any>);
    this.token = r.accessToken;
    this.refreshToken = r.refreshToken;
  }

  async start() {
    const otp = await this.api('POST', '/auth/otp/request', { phone: this.phone });
    if (!otp.devCode) throw new Error('Server must run with DEV_OTP=true for the simulator');
    const v = await this.api('POST', '/auth/otp/verify', { phone: this.phone, code: otp.devCode });
    this.token = v.accessToken;
    this.refreshToken = v.refreshToken;
    this.userId = v.userId;
    await this.api('PATCH', '/users/me', { name: this.name });

    const me = await this.api('GET', '/users/me');
    if (!me.driver) {
      const f = new FormData();
      const n = String(this.index).padStart(3, '0');
      f.set('cnicNumber', `35202-${String(9000000 + this.index)}-${this.index % 10}`);
      f.set('licenseNumber', `SIM-${n}`);
      f.set('vehicleType', this.vehicle.vehicleType);
      f.set('vehicleMake', this.vehicle.make);
      f.set('vehicleModel', this.vehicle.model);
      f.set('vehicleColor', this.vehicle.color);
      f.set('vehicleYear', String(2015 + (this.index % 9)));
      f.set('plateNumber', `SIM-${n}`);
      f.set('services', this.vehicle.services);
      const d = await this.api('POST', '/drivers/register', undefined, f);
      if (d.status !== 'approved') this.log('⚠️  Registered but not approved. Approve me in /admin or set AUTO_APPROVE_DRIVERS=true');
    } else if (me.driver.balance < 0) {
      await this.api('POST', '/drivers/me/topup', { amount: 1000, method: 'jazzcash' });
    }

    this.socket = io(SERVER, { transports: ['websocket'], auth: (cb) => cb({ token: this.token }) });
    this.socket.on('connect_error', async () => {
      await this.refresh().catch(() => undefined);
    });
    this.socket.on('ride:request', (r) => void this.onRequest(r));
    this.socket.on('ride:updated', (r) => void this.onRideUpdated(r));
    this.socket.on('offer:rejected', () => this.log('🙁 Passenger declined my offer'));

    await this.api('POST', '/drivers/me/online', { online: true, ...this.pos });
    this.log(`🟢 online at ${this.pos.lat.toFixed(4)}, ${this.pos.lng.toFixed(4)}`);

    // Restore a ride after restart
    const active = await this.api('GET', '/rides/active?role=driver');
    if (active.ride) void this.onRideUpdated(active.ride);

    // Small random moves while waiting (like a real car in the city)
    setInterval(() => {
      if (this.driving) return;
      const next = randomPointNear(this.pos, 25);
      this.heading = bearing(this.pos, next);
      this.pos = next;
      this.sendLocation();
    }, 4000);
  }

  sendLocation(speed = 0) {
    this.socket.emit('driver:location', { ...this.pos, heading: this.heading, speed });
  }

  async onRequest(r: any) {
    if (this.busyRideId) return;
    // 15% of drivers ignore a request (like real life)
    if (Math.random() < 0.15) return this.log(`🙈 skipped request ${r.rideId.slice(0, 8)}`);
    await sleep(rand(2000, 7000));
    const factor = [1, 1, 1.1, 1.2, 1.3][Math.floor(Math.random() * 5)]!;
    const price = Math.round((r.offeredFare * factor) / 10) * 10;
    try {
      await this.api('POST', `/rides/${r.rideId}/offers`, { price });
      this.log(`💬 offered PKR ${price} (passenger asked ${r.offeredFare}) - ${r.pickupDistanceM} m away`);
    } catch (e) {
      this.log(`offer failed: ${(e as Error).message}`);
    }
  }

  async onRideUpdated(ride: any) {
    if (ride.driver?.id !== this.userId) return;
    if (ride.status === 'accepted' && this.busyRideId !== ride.id) {
      this.busyRideId = ride.id;
      this.log(`✅ ACCEPTED! Going to pickup: ${ride.pickup.address}`);
      const route = await this.api('GET', `/maps/route?fromLat=${this.pos.lat}&fromLng=${this.pos.lng}&toLat=${ride.pickup.lat}&toLng=${ride.pickup.lng}`);
      const ok = await this.drive(decodePolyline(route.polyline), ride.id);
      if (!ok) return;
      await this.api('POST', `/rides/${ride.id}/arrived`);
      this.log('📍 Arrived at pickup. Waiting for passenger...');
      await sleep(10_000);
      if (this.busyRideId !== ride.id) return;
      await this.api('POST', `/rides/${ride.id}/start`);
      this.log(`🚗 Trip started to ${ride.dropoff.address}`);
      const path = ride.routePolyline ? decodePolyline(ride.routePolyline) : [ride.pickup, ride.dropoff];
      if (!(await this.drive(path, ride.id))) return;
      const done = await this.api('POST', `/rides/${ride.id}/complete`);
      this.log(`🏁 Trip completed. Fare PKR ${done.finalFare}, commission PKR ${done.commission}`);
      await this.api('POST', `/rides/${ride.id}/rate`, { stars: 5, review: 'Nice passenger' }).catch(() => undefined);
      this.busyRideId = null;
    }
    if (ride.status === 'cancelled' && this.busyRideId === ride.id) {
      this.log(`❌ Ride cancelled by ${ride.cancelledBy}: ${ride.cancelReason}`);
      this.busyRideId = null;
      this.driving = false;
    }
  }

  /** Moves along the road points at SPEED_MPS, sending GPS every second. Returns false if the ride was cancelled. */
  async drive(points: LatLng[], rideId: string): Promise<boolean> {
    this.driving = true;
    const path = [this.pos, ...points];
    for (let i = 1; i < path.length; i++) {
      const to = path[i]!;
      while (distanceM(this.pos, to) > 1) {
        if (this.busyRideId !== rideId) return (this.driving = false);
        const d = distanceM(this.pos, to);
        const step = Math.min(d, SPEED_MPS);
        const f = step / d;
        this.heading = bearing(this.pos, to);
        this.pos = { lat: this.pos.lat + (to.lat - this.pos.lat) * f, lng: this.pos.lng + (to.lng - this.pos.lng) * f };
        this.sendLocation(SPEED_MPS);
        await sleep(1000);
      }
    }
    this.driving = false;
    return true;
  }
}

async function main() {
  console.log(`Starting ${COUNT} simulated drivers near ${CENTER.lat}, ${CENTER.lng} -> ${SERVER}`);
  for (let i = 0; i < COUNT; i++) {
    const d = new SimDriver(i);
    await d.start().catch((e) => console.error(`Driver ${i} failed: ${(e as Error).message}`));
  }
  console.log('All drivers are online. Open the app and order a ride. Press Ctrl+C to stop.');
}

void main();

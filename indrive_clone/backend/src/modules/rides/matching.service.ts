import { and, eq, gt, inArray, ne, sql } from 'drizzle-orm';
import { env } from '../../config/env.js';
import { db } from '../../db/client.js';
import { ASSIGNED_RIDE_STATUSES, drivers, rideOffers, rides, users, type Ride, type User } from '../../db/schema.js';
import { scheduleJob, type JobData } from '../../jobs/queue.js';
import { distanceM, estimateEtaSec, fromXY, type LatLng } from '../../lib/geo.js';
import { logger } from '../../lib/logger.js';
import { redis } from '../../lib/redis.js';
import { emitToUser, emitToUsers } from '../../realtime/emitter.js';
import { Ev } from '../../realtime/events.js';
import { findDriversNear, getDriverLocation } from '../drivers/location.store.js';
import { loadRideDto, publicUser, rideCore } from './ride.dto.js';

/**
 * HOW INDRIVE FINDS A DRIVER (simplified):
 *
 * 1. Passenger creates a request with a price.
 * 2. We look for online drivers with the same vehicle type inside a circle around the pickup (3 km).
 * 3. Each driver sees the request and can: accept the price, offer a higher price, or skip.
 * 4. If nobody is chosen after 30 s, the circle grows (+2 km) up to 7 km and new drivers get the request.
 * 5. After 5 minutes the request expires. The passenger can raise the price at any time.
 */

export const notifiedKey = (rideId: string) => `ride:${rideId}:notified`;

/** What a driver sees in his request feed. */
export function requestDto(ride: Ride, passenger: User, driverLoc: LatLng | null, myOffer?: { id: string; price: number; status: string }) {
  const pickup = fromXY(ride.pickup);
  const core = rideCore(ride);
  return {
    rideId: ride.id,
    serviceType: ride.serviceType,
    vehicleType: ride.vehicleType,
    pickup: core.pickup,
    dropoff: core.dropoff,
    distanceM: ride.distanceM,
    durationS: ride.durationS,
    routePolyline: ride.routePolyline,
    offeredFare: ride.offeredFare,
    recommendedFare: ride.recommendedFare,
    paymentMethod: ride.paymentMethod,
    comment: ride.comment,
    details: ride.details,
    createdAt: ride.createdAt,
    expiresAt: ride.expiresAt,
    passenger: publicUser(passenger),
    pickupDistanceM: driverLoc ? Math.round(distanceM(driverLoc, pickup)) : null,
    pickupEtaSec: driverLoc ? estimateEtaSec(driverLoc, pickup) : null,
    myOffer: myOffer ?? null,
  };
}

/** Drivers that may receive a request: approved, online, offer this service, not busy, balance not negative. */
async function eligibleDrivers(candidateIds: string[], ride: Ride): Promise<Set<string>> {
  if (candidateIds.length === 0) return new Set();
  const rows = await db
    .select({ id: drivers.userId })
    .from(drivers)
    .where(
      and(
        inArray(drivers.userId, candidateIds),
        ne(drivers.userId, ride.passengerId),
        eq(drivers.status, 'approved'),
        eq(drivers.isOnline, true),
        sql`${ride.serviceType}::service_type = any(${drivers.services})`,
        sql`${drivers.balance} >= 0`,
        sql`not exists (select 1 from ${rides} r where r.driver_id = ${drivers.userId} and r.status in ('accepted','arrived','in_progress'))`,
      ),
    );
  return new Set(rows.map((r) => r.id));
}

/** Sends the request to every eligible driver inside the current circle who did not get it yet. */
export async function notifyNearbyDrivers(rideId: string): Promise<number> {
  const [row] = await db.select({ r: rides, p: users }).from(rides).innerJoin(users, eq(users.id, rides.passengerId)).where(eq(rides.id, rideId));
  if (!row || row.r.status !== 'searching') return 0;
  const { r: ride, p: passenger } = row;

  const near = await findDriversNear(ride.vehicleType, fromXY(ride.pickup), ride.searchRadiusM);
  const ok = await eligibleDrivers(
    near.map((n) => n.driverId),
    ride,
  );

  let sent = 0;
  for (const n of near) {
    if (!ok.has(n.driverId)) continue;
    const isNew = await redis.sadd(notifiedKey(ride.id), n.driverId);
    if (!isNew) continue;
    emitToUser(n.driverId, Ev.rideRequest, requestDto(ride, passenger, { lat: n.lat, lng: n.lng }));
    sent++;
  }
  await redis.expire(notifiedKey(ride.id), env.matching.intercityTtlSec + 600);
  const total = await redis.scard(notifiedKey(ride.id));
  emitToUser(ride.passengerId, Ev.searchProgress, { rideId: ride.id, radiusM: ride.searchRadiusM, driversNotified: total });
  logger.info({ rideId: ride.id, radius: ride.searchRadiusM, newDrivers: sent, total }, 'Request sent to drivers');
  return sent;
}

export async function startSearch(ride: Ride) {
  await notifyNearbyDrivers(ride.id);
  if (ride.serviceType !== 'intercity') {
    await scheduleJob({ type: 'expand-search', rideId: ride.id }, env.matching.expandEverySec * 1000, `expand-${ride.id}-${Date.now()}`);
  }
  await scheduleJob({ type: 'expire-ride', rideId: ride.id }, ride.expiresAt.getTime() - Date.now(), `expire-${ride.id}-${ride.expiresAt.getTime()}`);
}

/** Tell drivers who saw the request that it is closed, so it disappears from their screen. */
export async function closeRequestForDrivers(rideId: string, reason: 'taken' | 'cancelled' | 'expired', exceptDriverId?: string) {
  const ids = (await redis.smembers(notifiedKey(rideId))).filter((id) => id !== exceptDriverId);
  // Drivers who sent an offer must also be told, even if they found the request from the feed.
  const offered = await db.select({ id: rideOffers.driverId }).from(rideOffers).where(eq(rideOffers.rideId, rideId));
  const all = [...new Set([...ids, ...offered.map((o) => o.id)])].filter((id) => id !== exceptDriverId);
  emitToUsers(all, Ev.rideRequestClosed, { rideId, reason });
  await redis.del(notifiedKey(rideId));
}

/* --------------------------- Timed jobs --------------------------- */

async function handleExpand(rideId: string) {
  const [ride] = await db.select().from(rides).where(eq(rides.id, rideId));
  if (!ride || ride.status !== 'searching') return;

  const m = env.matching;
  if (ride.searchRadiusM < m.maxRadiusM) {
    const radius = Math.min(m.maxRadiusM, ride.searchRadiusM + m.radiusStepM);
    await db.update(rides).set({ searchRadiusM: radius }).where(and(eq(rides.id, rideId), eq(rides.status, 'searching')));
  }
  // Also catches drivers who came online inside the circle since last time.
  await notifyNearbyDrivers(rideId);

  if (Date.now() + m.expandEverySec * 1000 < ride.expiresAt.getTime()) {
    await scheduleJob({ type: 'expand-search', rideId }, m.expandEverySec * 1000, `expand-${rideId}-${Date.now()}`);
  }
}

async function handleExpireRide(rideId: string) {
  const [ride] = await db
    .update(rides)
    .set({ status: 'expired', cancelledAt: new Date(), cancelledBy: 'system', cancelReason: 'No driver was chosen in time' })
    .where(and(eq(rides.id, rideId), eq(rides.status, 'searching'), sql`${rides.expiresAt} <= now() + interval '2 seconds'`))
    .returning();
  if (!ride) return;
  await db.update(rideOffers).set({ status: 'expired' }).where(and(eq(rideOffers.rideId, rideId), eq(rideOffers.status, 'pending')));
  await closeRequestForDrivers(rideId, 'expired');
  emitToUser(ride.passengerId, Ev.rideUpdated, await loadRideDto(rideId));
}

async function handleExpireOffer(offerId: string) {
  const [offer] = await db
    .update(rideOffers)
    .set({ status: 'expired' })
    .where(and(eq(rideOffers.id, offerId), eq(rideOffers.status, 'pending')))
    .returning();
  if (!offer) return;
  const [ride] = await db.select({ passengerId: rides.passengerId }).from(rides).where(eq(rides.id, offer.rideId));
  if (ride) emitToUser(ride.passengerId, Ev.offerUpdated, { offerId, rideId: offer.rideId, status: 'expired' });
  emitToUser(offer.driverId, Ev.offerExpired, { offerId, rideId: offer.rideId });
}

export async function handleJob(data: JobData) {
  if (data.type === 'expand-search') return handleExpand(data.rideId);
  if (data.type === 'expire-ride') return handleExpireRide(data.rideId);
  if (data.type === 'expire-offer') return handleExpireOffer(data.offerId);
}

/* ----------------------- Driver request feed ----------------------- */

/**
 * Open requests a driver can see right now (used when he goes online or pulls to refresh).
 * A driver sees a request only if he is inside that request's current search circle.
 */
export async function openRequestsForDriver(driverId: string) {
  const [driver] = await db.select().from(drivers).where(eq(drivers.userId, driverId));
  if (!driver || driver.status !== 'approved' || !driver.isOnline) return [];
  const loc = await getDriverLocation(driverId);
  if (!loc) return [];

  const busy = await db
    .select({ id: rides.id })
    .from(rides)
    .where(and(eq(rides.driverId, driverId), inArray(rides.status, ASSIGNED_RIDE_STATUSES)));
  if (busy.length) return [];

  const here = sql`ST_SetSRID(ST_MakePoint(${loc.lng}, ${loc.lat}), 4326)::geography`;
  const rows = await db
    .select({ r: rides, p: users })
    .from(rides)
    .innerJoin(users, eq(users.id, rides.passengerId))
    .where(
      and(
        eq(rides.status, 'searching'),
        eq(rides.vehicleType, driver.vehicleType),
        inArray(rides.serviceType, driver.services),
        ne(rides.passengerId, driverId),
        gt(rides.expiresAt, new Date()),
        sql`ST_DWithin(${rides.pickup}::geography, ${here}, ${rides.searchRadiusM})`,
      ),
    )
    .orderBy(sql`ST_Distance(${rides.pickup}::geography, ${here})`)
    .limit(30);

  const offers = rows.length
    ? await db
        .select()
        .from(rideOffers)
        .where(and(eq(rideOffers.driverId, driverId), inArray(rideOffers.rideId, rows.map((x) => x.r.id))))
    : [];
  const byRide = new Map(offers.map((o) => [o.rideId, o]));

  for (const { r } of rows) await redis.sadd(notifiedKey(r.id), driverId);
  return rows.map(({ r, p }) => {
    const o = byRide.get(r.id);
    return requestDto(r, p, loc, o ? { id: o.id, price: o.price, status: o.status } : undefined);
  });
}

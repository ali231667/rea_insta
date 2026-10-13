import { and, desc, eq, inArray, lt, ne, sql } from 'drizzle-orm';
import { env } from '../../config/env.js';
import { db } from '../../db/client.js';
import {
  ACTIVE_RIDE_STATUSES,
  ASSIGNED_RIDE_STATUSES,
  drivers,
  messages,
  rideOffers,
  rides,
  sosAlerts,
  users,
  walletTransactions,
  type Ride,
  type RideDetails,
  type ServiceType,
  type VehicleType,
} from '../../db/schema.js';
import { scheduleJob } from '../../jobs/queue.js';
import { badRequest, conflict, forbidden, notFound } from '../../lib/errors.js';
import { distanceM, estimateEtaSec, fromXY, toXY, type LatLng } from '../../lib/geo.js';
import { sendPush } from '../../lib/push.js';
import { redis } from '../../lib/redis.js';
import { emitToUser, emitToUsers } from '../../realtime/emitter.js';
import { Ev } from '../../realtime/events.js';
import { getDriverLocation, markDriverFree } from '../drivers/location.store.js';
import { getRoute } from '../maps/maps.service.js';
import { commissionFor, quoteAll, quoteFare, SERVICE_VEHICLES } from './fare.js';
import { closeRequestForDrivers, notifiedKey, notifyNearbyDrivers, startSearch } from './matching.service.js';
import { loadPublicDrivers, loadRideDto, offerDto, rideCore } from './ride.dto.js';

type Point = LatLng & { address: string };

const isUniqueViolation = (e: unknown) => {
  const err = e as { code?: string; cause?: { code?: string } };
  return err?.code === '23505' || err?.cause?.code === '23505';
};

async function getRideOr404(rideId: string): Promise<Ride> {
  const [ride] = await db.select().from(rides).where(eq(rides.id, rideId));
  if (!ride) throw notFound('Ride not found');
  return ride;
}

async function freeDriver(driverId: string | null) {
  if (!driverId) return;
  const [d] = await db.select({ isOnline: drivers.isOnline }).from(drivers).where(eq(drivers.userId, driverId));
  await markDriverFree(driverId, !!d?.isOnline);
}

/** Push the fresh ride to passenger and driver. */
async function broadcastRide(ride: Ride) {
  const dto = await loadRideDto(ride.id);
  emitToUsers([ride.passengerId, ...(ride.driverId ? [ride.driverId] : [])], Ev.rideUpdated, dto);
  return dto;
}

/* ------------------------------ Estimate ------------------------------ */

export async function estimate(service: ServiceType, pickup: LatLng, dropoff: LatLng) {
  const route = await getRoute(pickup, dropoff);
  return {
    distanceM: route.distanceM,
    durationS: route.durationS,
    routePolyline: route.polyline,
    routeSource: route.source,
    options: quoteAll(service, route.distanceM, route.durationS),
  };
}

/* ------------------------------ Create ------------------------------ */

export type CreateRideInput = {
  serviceType: ServiceType;
  vehicleType: VehicleType;
  pickup: Point;
  dropoff: Point;
  offeredFare: number;
  comment?: string;
  details?: RideDetails;
};

export async function createRide(passengerId: string, input: CreateRideInput) {
  if (!SERVICE_VEHICLES[input.serviceType].includes(input.vehicleType)) {
    throw badRequest(`${input.vehicleType} is not available for ${input.serviceType}`);
  }
  if (distanceM(input.pickup, input.dropoff) < 100) throw badRequest('Pickup and destination are too close');

  const route = await getRoute(input.pickup, input.dropoff);
  const quote = quoteFare(input.serviceType, input.vehicleType, route.distanceM, route.durationS);
  if (input.offeredFare < quote.minFare) throw badRequest(`Minimum fare is PKR ${quote.minFare}`, 'fare_too_low');
  if (input.offeredFare > quote.maxFare) throw badRequest(`Fare is too high (max PKR ${quote.maxFare})`, 'fare_too_high');

  const intercity = input.serviceType === 'intercity';
  const ttl = intercity ? env.matching.intercityTtlSec : env.matching.requestTtlSec;

  let ride: Ride;
  try {
    [ride] = (await db
      .insert(rides)
      .values({
        passengerId,
        serviceType: input.serviceType,
        vehicleType: input.vehicleType,
        pickup: toXY(input.pickup),
        pickupAddress: input.pickup.address,
        dropoff: toXY(input.dropoff),
        dropoffAddress: input.dropoff.address,
        distanceM: route.distanceM,
        durationS: route.durationS,
        routePolyline: route.polyline,
        recommendedFare: quote.recommendedFare,
        minFare: quote.minFare,
        offeredFare: input.offeredFare,
        comment: input.comment,
        details: input.details ?? {},
        searchRadiusM: intercity ? env.matching.intercityRadiusM : env.matching.initialRadiusM,
        expiresAt: new Date(Date.now() + ttl * 1000),
      })
      .returning()) as [Ride];
  } catch (e) {
    if (isUniqueViolation(e)) throw conflict('You already have an active ride', 'active_ride_exists');
    throw e;
  }

  await startSearch(ride);
  return loadRideDto(ride.id);
}

/* --------------------------- Passenger actions --------------------------- */

/** "Raise fare" button: passenger offers more money so more drivers are interested. */
export async function raiseFare(passengerId: string, rideId: string, newFare: number) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== passengerId) throw forbidden();
  if (ride.status !== 'searching') throw conflict('This request is closed');
  if (newFare <= ride.offeredFare) throw badRequest('New fare must be higher than the current fare');
  if (newFare > ride.recommendedFare * 5) throw badRequest('Fare is too high');

  const [updated] = (await db.update(rides).set({ offeredFare: newFare }).where(eq(rides.id, rideId)).returning()) as [Ride];
  // Drivers already looking at it get the new price; drivers who skipped it may now want it.
  const notified = await redis.smembers(notifiedKey(rideId));
  emitToUsers(notified, Ev.rideRequestUpdated, { rideId, offeredFare: newFare });
  // Offers below the new price are not valid anymore.
  const low = await db
    .update(rideOffers)
    .set({ status: 'expired' })
    .where(and(eq(rideOffers.rideId, rideId), eq(rideOffers.status, 'pending'), lt(rideOffers.price, newFare)))
    .returning();
  for (const o of low) emitToUser(o.driverId, Ev.offerExpired, { offerId: o.id, rideId });
  await notifyNearbyDrivers(rideId);
  return broadcastRide(updated);
}

export async function acceptOffer(passengerId: string, rideId: string, offerId: string) {
  let accepted: Ride;
  try {
    accepted = await db.transaction(async (tx) => {
      // Lock the ride row so two "accept" taps cannot both win.
      const [ride] = await tx.select().from(rides).where(eq(rides.id, rideId)).for('update');
      if (!ride) throw notFound('Ride not found');
      if (ride.passengerId !== passengerId) throw forbidden();
      if (ride.status !== 'searching') throw conflict('This request is already closed');

      const [offer] = await tx.select().from(rideOffers).where(and(eq(rideOffers.id, offerId), eq(rideOffers.rideId, rideId)));
      if (!offer) throw notFound('Offer not found');
      if (offer.status !== 'pending' || offer.expiresAt < new Date()) throw conflict('This offer has expired', 'offer_expired');

      const [r] = (await tx
        .update(rides)
        .set({ status: 'accepted', driverId: offer.driverId, finalFare: offer.price, acceptedAt: new Date() })
        .where(eq(rides.id, rideId))
        .returning()) as [Ride];
      await tx.update(rideOffers).set({ status: 'accepted' }).where(eq(rideOffers.id, offerId));
      await tx
        .update(rideOffers)
        .set({ status: 'rejected' })
        .where(and(eq(rideOffers.rideId, rideId), ne(rideOffers.id, offerId), eq(rideOffers.status, 'pending')));
      return r;
    });
  } catch (e) {
    // Unique index: this driver already got another ride a moment ago.
    if (isUniqueViolation(e)) {
      await db.update(rideOffers).set({ status: 'withdrawn' }).where(eq(rideOffers.id, offerId));
      throw conflict('This driver just took another ride. Please choose another offer.', 'driver_busy');
    }
    throw e;
  }

  await closeRequestForDrivers(rideId, 'taken', accepted.driverId!);
  sendPush(accepted.driverId!, { title: 'The passenger chose you! 🎉', body: `Go to ${accepted.pickupAddress}`, route: '/driver/ride' });
  return broadcastRide(accepted);
}

export async function declineOffer(passengerId: string, rideId: string, offerId: string) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== passengerId) throw forbidden();
  const [offer] = await db
    .update(rideOffers)
    .set({ status: 'rejected' })
    .where(and(eq(rideOffers.id, offerId), eq(rideOffers.rideId, rideId), eq(rideOffers.status, 'pending')))
    .returning();
  if (offer) emitToUser(offer.driverId, Ev.offerRejected, { offerId, rideId });
  return { ok: true };
}

/* --------------------------- Driver actions --------------------------- */

export async function makeOffer(driverId: string, rideId: string, price: number) {
  const ride = await getRideOr404(rideId);
  if (ride.status !== 'searching' || ride.expiresAt < new Date()) throw conflict('This request is already closed', 'request_closed');
  if (ride.passengerId === driverId) throw badRequest('You cannot take your own ride');
  if (price < ride.offeredFare) throw badRequest(`Your price cannot be lower than the passenger's price (PKR ${ride.offeredFare})`);
  if (price > ride.offeredFare * 3) throw badRequest('Price is too high');

  const [driver] = await db.select().from(drivers).where(eq(drivers.userId, driverId));
  if (!driver || driver.status !== 'approved') throw forbidden('Driver account not approved');
  if (!driver.isOnline) throw conflict('Go online to send offers', 'driver_offline');
  if (driver.vehicleType !== ride.vehicleType) throw badRequest('Your vehicle type does not match this request');
  if (driver.balance < 0) throw forbidden('Your balance is negative. Please top up to receive orders.', 'negative_balance');

  const [busy] = await db
    .select({ id: rides.id })
    .from(rides)
    .where(and(eq(rides.driverId, driverId), inArray(rides.status, ASSIGNED_RIDE_STATUSES)));
  if (busy) throw conflict('Finish your current ride first', 'driver_busy');

  const loc = (await getDriverLocation(driverId)) ?? (driver.lastLocation ? fromXY(driver.lastLocation) : null);
  const pickup = fromXY(ride.pickup);
  const dist = loc ? Math.round(distanceM(loc, pickup)) : 0;
  const eta = loc ? estimateEtaSec(loc, pickup) : 300;
  const expiresAt = new Date(Date.now() + env.matching.offerTtlSec * 1000);

  // One offer per driver per ride. Sending again replaces the old one.
  const [offer] = await db
    .insert(rideOffers)
    .values({ rideId, driverId, price, etaSec: eta, distanceM: dist, expiresAt })
    .onConflictDoUpdate({
      target: [rideOffers.rideId, rideOffers.driverId],
      set: { price, etaSec: eta, distanceM: dist, expiresAt, status: 'pending', createdAt: new Date() },
      setWhere: sql`${rideOffers.status} <> 'accepted'`,
    })
    .returning();
  if (!offer) throw conflict('Offer could not be sent');

  await scheduleJob({ type: 'expire-offer', offerId: offer.id }, env.matching.offerTtlSec * 1000, `offer-${offer.id}-${expiresAt.getTime()}`);

  const driverInfo = (await loadPublicDrivers([driverId])).get(driverId);
  const dto = offerDto(offer, driverInfo);
  emitToUser(ride.passengerId, Ev.offerNew, dto);
  sendPush(ride.passengerId, {
    title: `New offer: PKR ${price}`,
    body: `${driverInfo?.name ?? 'A driver'} · ${driverInfo?.vehicle.make ?? ''} ${driverInfo?.vehicle.model ?? ''} · ${Math.ceil(eta / 60)} min away`,
    route: '/ride',
  });
  return dto;
}

async function assertDriverOfRide(driverId: string, rideId: string) {
  const ride = await getRideOr404(rideId);
  if (ride.driverId !== driverId) throw forbidden('This is not your ride');
  return ride;
}

/** Driver reached the pickup point. Passenger gets "Your driver has arrived". */
export async function driverArrived(driverId: string, rideId: string) {
  const ride = await assertDriverOfRide(driverId, rideId);
  if (ride.status !== 'accepted') throw conflict(`Cannot mark arrived when ride is ${ride.status}`);
  const [r] = (await db.update(rides).set({ status: 'arrived', arrivedAt: new Date() }).where(eq(rides.id, rideId)).returning()) as [Ride];
  sendPush(r.passengerId, { title: 'Your driver has arrived 🚗', body: 'Please go to the pickup point.', route: '/ride' });
  return broadcastRide(r);
}

export async function startRide(driverId: string, rideId: string) {
  const ride = await assertDriverOfRide(driverId, rideId);
  if (ride.status !== 'arrived' && ride.status !== 'accepted') throw conflict(`Cannot start when ride is ${ride.status}`);
  const [r] = (await db
    .update(rides)
    .set({ status: 'in_progress', startedAt: new Date(), arrivedAt: ride.arrivedAt ?? new Date() })
    .where(eq(rides.id, rideId))
    .returning()) as [Ride];
  return broadcastRide(r);
}

/** Trip finished. Passenger pays cash. Platform commission is taken from the driver's balance. */
export async function completeRide(driverId: string, rideId: string) {
  const ride = await assertDriverOfRide(driverId, rideId);
  if (ride.status !== 'in_progress') throw conflict(`Cannot complete when ride is ${ride.status}`);
  const fare = ride.finalFare ?? ride.offeredFare;
  const commission = commissionFor(fare, env.commissionRate);

  const r = await db.transaction(async (tx) => {
    const [done] = (await tx
      .update(rides)
      .set({ status: 'completed', completedAt: new Date(), commission })
      .where(and(eq(rides.id, rideId), eq(rides.status, 'in_progress')))
      .returning()) as [Ride | undefined];
    if (!done) throw conflict('Ride already completed');
    await tx.update(drivers).set({ balance: sql`${drivers.balance} - ${commission}` }).where(eq(drivers.userId, driverId));
    await tx.insert(walletTransactions).values({ driverId, amount: -commission, type: 'commission', rideId, note: `Commission ${Math.round(env.commissionRate * 100)}% of PKR ${fare}` });
    return done;
  });

  const [d] = await db.select({ balance: drivers.balance }).from(drivers).where(eq(drivers.userId, driverId));
  emitToUser(driverId, Ev.balanceUpdated, { balance: d?.balance ?? 0 });
  await freeDriver(driverId);
  sendPush(r.passengerId, { title: 'You have arrived', body: `Please pay PKR ${fare} in cash. Rate your driver.`, route: `/rate/${r.id}` });
  return broadcastRide(r);
}

/* ------------------------------ Cancel ------------------------------ */

export async function cancelRide(userId: string, rideId: string, reason: string) {
  const ride = await getRideOr404(rideId);
  const isPassenger = ride.passengerId === userId;
  const isDriver = ride.driverId === userId;
  if (!isPassenger && !isDriver) throw forbidden();

  const allowed = isPassenger ? ['searching', 'accepted', 'arrived'] : ['accepted', 'arrived'];
  if (!allowed.includes(ride.status)) throw conflict(`You cannot cancel when the ride is ${ride.status}`);

  const [r] = (await db
    .update(rides)
    .set({ status: 'cancelled', cancelledAt: new Date(), cancelledBy: isPassenger ? 'passenger' : 'driver', cancelReason: reason })
    .where(and(eq(rides.id, rideId), inArray(rides.status, ACTIVE_RIDE_STATUSES)))
    .returning()) as [Ride | undefined];
  if (!r) throw conflict('Ride already finished');

  if (ride.status === 'searching') {
    await db.update(rideOffers).set({ status: 'expired' }).where(and(eq(rideOffers.rideId, rideId), eq(rideOffers.status, 'pending')));
    await closeRequestForDrivers(rideId, 'cancelled');
  }
  await freeDriver(r.driverId);
  const other = isPassenger ? r.driverId : r.passengerId;
  if (other) {
    sendPush(other, {
      title: isPassenger ? 'The passenger cancelled the ride' : 'The driver cancelled the ride',
      body: reason,
      route: isPassenger ? '/driver' : '/ride',
    });
  }
  return broadcastRide(r);
}

/* ------------------------------ Rating ------------------------------ */

export async function rateRide(userId: string, rideId: string, stars: number, review?: string) {
  const ride = await getRideOr404(rideId);
  if (ride.status !== 'completed') throw conflict('You can rate only completed rides');

  if (ride.passengerId === userId) {
    if (ride.driverStars) throw conflict('Already rated');
    await db.transaction(async (tx) => {
      await tx.update(rides).set({ driverStars: stars, driverReview: review }).where(eq(rides.id, rideId));
      // New average = (old average * count + new stars) / (count + 1)
      await tx
        .update(drivers)
        .set({
          rating: sql`(${drivers.rating} * ${drivers.ratingCount} + ${stars}) / (${drivers.ratingCount} + 1)`,
          ratingCount: sql`${drivers.ratingCount} + 1`,
        })
        .where(eq(drivers.userId, ride.driverId!));
    });
  } else if (ride.driverId === userId) {
    if (ride.passengerStars) throw conflict('Already rated');
    await db.transaction(async (tx) => {
      await tx.update(rides).set({ passengerStars: stars, passengerReview: review }).where(eq(rides.id, rideId));
      await tx
        .update(users)
        .set({
          rating: sql`(${users.rating} * ${users.ratingCount} + ${stars}) / (${users.ratingCount} + 1)`,
          ratingCount: sql`${users.ratingCount} + 1`,
        })
        .where(eq(users.id, ride.passengerId));
    });
  } else {
    throw forbidden();
  }
  return { ok: true };
}

/* ------------------------------ Queries ------------------------------ */

export async function getRideForUser(userId: string, rideId: string) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== userId && ride.driverId !== userId) throw forbidden();
  return loadRideDto(rideId);
}

/** The ride the user is in right now (to restore the screen after the app restarts). */
export async function activeRide(userId: string, role: 'passenger' | 'driver') {
  const cond =
    role === 'passenger'
      ? and(eq(rides.passengerId, userId), inArray(rides.status, ACTIVE_RIDE_STATUSES))
      : and(eq(rides.driverId, userId), inArray(rides.status, ASSIGNED_RIDE_STATUSES));
  const [ride] = await db.select({ id: rides.id }).from(rides).where(cond).limit(1);
  return ride ? loadRideDto(ride.id) : null;
}

export async function history(userId: string, role: 'passenger' | 'driver', limit = 20, before?: Date) {
  const who = role === 'passenger' ? eq(rides.passengerId, userId) : eq(rides.driverId, userId);
  const list = await db
    .select()
    .from(rides)
    .where(
      and(
        who,
        role === 'driver' ? inArray(rides.status, ['completed', 'cancelled']) : inArray(rides.status, ['completed', 'cancelled', 'expired']),
        before ? lt(rides.createdAt, before) : undefined,
      ),
    )
    .orderBy(desc(rides.createdAt))
    .limit(limit);
  const ds = await loadPublicDrivers([...new Set(list.map((r) => r.driverId).filter((x): x is string => !!x))]);
  return list.map((r) => ({ ...rideCore(r), driver: r.driverId ? (ds.get(r.driverId) ?? null) : null }));
}

/** Last places the passenger went to (shown under "Where to?"). */
export async function recentDestinations(userId: string) {
  const rows = await db.execute<{ address: string; lat: number; lng: number }>(sql`
    select address, lat, lng from (
      select distinct on (dropoff_address) dropoff_address as address, ST_Y(dropoff) as lat, ST_X(dropoff) as lng, created_at
      from ${rides} where passenger_id = ${userId}
      order by dropoff_address, created_at desc
    ) t order by created_at desc limit 5`);
  return rows.rows.map((r) => ({ address: r.address, lat: Number(r.lat), lng: Number(r.lng) }));
}

/* ------------------------------ Chat ------------------------------ */

export async function listMessages(userId: string, rideId: string) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== userId && ride.driverId !== userId) throw forbidden();
  return db.select().from(messages).where(eq(messages.rideId, rideId)).orderBy(messages.createdAt);
}

export async function sendMessage(userId: string, rideId: string, body: string) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== userId && ride.driverId !== userId) throw forbidden();
  if (!ride.driverId || !ASSIGNED_RIDE_STATUSES.includes(ride.status)) throw conflict('Chat is open only during a ride');
  const [msg] = await db.insert(messages).values({ rideId, senderId: userId, body }).returning();
  emitToUsers([ride.passengerId, ride.driverId], Ev.chatMessage, msg);
  const to = userId === ride.passengerId ? ride.driverId : ride.passengerId;
  sendPush(to, { title: 'New message', body: body.slice(0, 120), route: `/chat/${rideId}` });
  return msg;
}

/* ------------------------------ Safety ------------------------------ */

export async function sos(userId: string, rideId: string, loc?: LatLng) {
  const ride = await getRideOr404(rideId);
  if (ride.passengerId !== userId && ride.driverId !== userId) throw forbidden();
  const [alert] = await db
    .insert(sosAlerts)
    .values({ rideId, userId, location: loc ? toXY(loc) : null })
    .returning();
  return { ok: true, alertId: alert?.id, emergencyNumbers: { police: '15', rescue: '1122', ambulance: '115' } };
}


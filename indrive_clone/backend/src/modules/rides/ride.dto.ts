import { and, eq, inArray, sql } from 'drizzle-orm';
import { db } from '../../db/client.js';
import { drivers, rideOffers, rides, users, type Driver, type Ride, type RideOffer, type User } from '../../db/schema.js';
import { fromXY } from '../../lib/geo.js';
import { notFound } from '../../lib/errors.js';

/** Data sent to the app. We never send phone numbers of strangers, only of matched rider/driver. */

export function publicUser(u: User, withPhone = false) {
  return {
    id: u.id,
    name: u.name ?? 'Passenger',
    photoUrl: u.photoUrl,
    rating: Math.round(u.rating * 100) / 100,
    ratingCount: u.ratingCount,
    ...(withPhone ? { phone: u.phone } : {}),
  };
}

export function publicDriver(u: User, d: Driver, tripsCount: number, withPhone = false) {
  return {
    id: u.id,
    name: u.name ?? 'Driver',
    photoUrl: d.docs.selfie ?? u.photoUrl,
    rating: Math.round(d.rating * 100) / 100,
    ratingCount: d.ratingCount,
    tripsCount,
    vehicle: {
      type: d.vehicleType,
      make: d.vehicleMake,
      model: d.vehicleModel,
      color: d.vehicleColor,
      year: d.vehicleYear,
      plateNumber: d.plateNumber,
      photoUrl: d.docs.vehicle,
    },
    ...(withPhone ? { phone: u.phone } : {}),
  };
}

export type PublicDriver = ReturnType<typeof publicDriver>;

export async function tripsCountOf(driverIds: string[]): Promise<Map<string, number>> {
  if (driverIds.length === 0) return new Map();
  const rows = await db
    .select({ driverId: rides.driverId, n: sql<number>`count(*)::int` })
    .from(rides)
    .where(and(inArray(rides.driverId, driverIds), eq(rides.status, 'completed')))
    .groupBy(rides.driverId);
  return new Map(rows.map((r) => [r.driverId!, r.n]));
}

export async function loadPublicDrivers(driverIds: string[], withPhone = false): Promise<Map<string, PublicDriver>> {
  if (driverIds.length === 0) return new Map();
  const rows = await db
    .select({ u: users, d: drivers })
    .from(drivers)
    .innerJoin(users, eq(users.id, drivers.userId))
    .where(inArray(drivers.userId, driverIds));
  const trips = await tripsCountOf(driverIds);
  return new Map(rows.map(({ u, d }) => [u.id, publicDriver(u, d, trips.get(u.id) ?? 0, withPhone)]));
}

export function rideCore(r: Ride) {
  return {
    id: r.id,
    status: r.status,
    serviceType: r.serviceType,
    vehicleType: r.vehicleType,
    pickup: { ...fromXY(r.pickup), address: r.pickupAddress },
    dropoff: { ...fromXY(r.dropoff), address: r.dropoffAddress },
    distanceM: r.distanceM,
    durationS: r.durationS,
    routePolyline: r.routePolyline,
    recommendedFare: r.recommendedFare,
    minFare: r.minFare,
    offeredFare: r.offeredFare,
    finalFare: r.finalFare,
    paymentMethod: r.paymentMethod,
    comment: r.comment,
    details: r.details,
    searchRadiusM: r.searchRadiusM,
    expiresAt: r.expiresAt,
    createdAt: r.createdAt,
    acceptedAt: r.acceptedAt,
    arrivedAt: r.arrivedAt,
    startedAt: r.startedAt,
    completedAt: r.completedAt,
    cancelledAt: r.cancelledAt,
    cancelledBy: r.cancelledBy,
    cancelReason: r.cancelReason,
    driverStars: r.driverStars,
    passengerStars: r.passengerStars,
    commission: r.commission,
  };
}

export function offerDto(o: RideOffer, driver: PublicDriver | undefined) {
  return {
    id: o.id,
    rideId: o.rideId,
    price: o.price,
    etaSec: o.etaSec,
    distanceM: o.distanceM,
    status: o.status,
    createdAt: o.createdAt,
    expiresAt: o.expiresAt,
    driver,
  };
}

/**
 * Full ride object for the passenger or the driver of that ride.
 * Phone numbers are shared only after the driver is assigned (so they can call each other).
 */
export async function loadRideDto(rideId: string) {
  const [row] = await db.select({ r: rides, p: users }).from(rides).innerJoin(users, eq(users.id, rides.passengerId)).where(eq(rides.id, rideId));
  if (!row) throw notFound('Ride not found');
  const { r, p } = row;
  const assigned = ['accepted', 'arrived', 'in_progress'].includes(r.status);

  let driver: PublicDriver | null = null;
  if (r.driverId) driver = (await loadPublicDrivers([r.driverId], assigned)).get(r.driverId) ?? null;

  let offers: ReturnType<typeof offerDto>[] = [];
  if (r.status === 'searching') {
    const list = await db
      .select()
      .from(rideOffers)
      .where(and(eq(rideOffers.rideId, r.id), eq(rideOffers.status, 'pending'), sql`${rideOffers.expiresAt} > now()`));
    const ds = await loadPublicDrivers(list.map((o) => o.driverId));
    offers = list.map((o) => offerDto(o, ds.get(o.driverId)));
  }

  return { ...rideCore(r), passenger: publicUser(p, assigned), driver, offers };
}

export type RideDto = Awaited<ReturnType<typeof loadRideDto>>;

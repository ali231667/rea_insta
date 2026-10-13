import { and, desc, eq, gte, inArray, sql } from 'drizzle-orm';
import { env } from '../../config/env.js';
import { db } from '../../db/client.js';
import {
  ASSIGNED_RIDE_STATUSES,
  drivers,
  rides,
  vehicleTypeEnum,
  walletTransactions,
  type DriverDocs,
  type ServiceType,
  type VehicleType,
} from '../../db/schema.js';
import { badRequest, conflict, forbidden, notFound } from '../../lib/errors.js';
import { distanceM, estimateEtaSec, fromXY, toXY, type LatLng } from '../../lib/geo.js';
import { redis } from '../../lib/redis.js';
import { emitToUser } from '../../realtime/emitter.js';
import { Ev } from '../../realtime/events.js';
import { SERVICE_VEHICLES } from '../rides/fare.js';
import { findDriversNear, getDriverLocation, removeDriver, setDriverLocation } from './location.store.js';

export type RegisterDriverInput = {
  cnicNumber: string;
  licenseNumber: string;
  vehicleType: VehicleType;
  vehicleMake: string;
  vehicleModel: string;
  vehicleColor: string;
  vehicleYear?: number;
  plateNumber: string;
  services: ServiceType[];
};

const isUniqueViolation = (e: unknown) => {
  const err = e as { code?: string; cause?: { code?: string; constraint?: string }; constraint?: string };
  return err?.code === '23505' || err?.cause?.code === '23505';
};

export async function getDriverProfile(userId: string) {
  const [d] = await db.select().from(drivers).where(eq(drivers.userId, userId));
  if (!d) return null;
  return {
    status: d.status,
    rejectionReason: d.rejectionReason,
    cnicNumber: d.cnicNumber,
    licenseNumber: d.licenseNumber,
    vehicle: {
      type: d.vehicleType,
      make: d.vehicleMake,
      model: d.vehicleModel,
      color: d.vehicleColor,
      year: d.vehicleYear,
      plateNumber: d.plateNumber,
    },
    services: d.services,
    docs: d.docs,
    rating: Math.round(d.rating * 100) / 100,
    ratingCount: d.ratingCount,
    balance: d.balance,
    isOnline: d.isOnline,
    createdAt: d.createdAt,
  };
}

/** Driver sign-up (CNIC, license, vehicle, photos). */
export async function registerDriver(userId: string, input: RegisterDriverInput, docs: DriverDocs) {
  // Services must fit the vehicle (a bike cannot do freight).
  const services = input.services.filter((s) => SERVICE_VEHICLES[s].includes(input.vehicleType));
  if (services.length === 0) throw badRequest('Your vehicle cannot be used for the selected services');

  const [existing] = await db.select().from(drivers).where(eq(drivers.userId, userId));
  if (existing && existing.status !== 'rejected') throw conflict('You are already registered as a driver');

  const approved = env.autoApproveDrivers;
  const values = {
    ...input,
    plateNumber: input.plateNumber.toUpperCase().replace(/\s+/g, '-'),
    services,
    docs: { ...(existing?.docs ?? {}), ...docs },
    status: approved ? ('approved' as const) : ('pending' as const),
    approvedAt: approved ? new Date() : null,
    rejectionReason: null,
  };

  try {
    await db.transaction(async (tx) => {
      if (existing) {
        await tx.update(drivers).set(values).where(eq(drivers.userId, userId));
      } else {
        await tx.insert(drivers).values({ userId, ...values, balance: env.driverStartBalance });
        await tx.insert(walletTransactions).values({ driverId: userId, amount: env.driverStartBalance, type: 'bonus', note: 'Welcome bonus' });
      }
    });
  } catch (e) {
    if (isUniqueViolation(e)) throw conflict('This CNIC or number plate is already registered', 'duplicate_driver');
    throw e;
  }
  return getDriverProfile(userId);
}

export async function updateServices(userId: string, services: ServiceType[]) {
  const [d] = await db.select().from(drivers).where(eq(drivers.userId, userId));
  if (!d) throw notFound('Not a driver');
  const ok = services.filter((s) => SERVICE_VEHICLES[s].includes(d.vehicleType));
  if (!ok.length) throw badRequest('Choose at least one service that fits your vehicle');
  await db.update(drivers).set({ services: ok }).where(eq(drivers.userId, userId));
  return getDriverProfile(userId);
}

/** Online = driver receives requests. Offline = he is hidden from passengers. */
export async function setOnline(userId: string, online: boolean, loc?: LatLng & { heading?: number }) {
  const [d] = await db.select().from(drivers).where(eq(drivers.userId, userId));
  if (!d) throw notFound('Not a driver');
  if (online) {
    if (d.status !== 'approved') throw forbidden('Your account is not approved yet', 'driver_not_approved');
    if (d.balance < 0) throw forbidden('Your balance is negative. Please top up first.', 'negative_balance');
    if (!loc) throw badRequest('Location is needed to go online');
    await setDriverLocation(userId, d.vehicleType, loc, loc.heading);
    await db.update(drivers).set({ isOnline: true, lastLocation: toXY(loc), lastSeenAt: new Date() }).where(eq(drivers.userId, userId));
  } else {
    const [busy] = await db
      .select({ id: rides.id })
      .from(rides)
      .where(and(eq(rides.driverId, userId), inArray(rides.status, ASSIGNED_RIDE_STATUSES)));
    if (busy) throw conflict('Finish your current ride before going offline');
    await removeDriver(userId, d.vehicleType);
    await db.update(drivers).set({ isOnline: false }).where(eq(drivers.userId, userId));
  }
  return { isOnline: online };
}

/**
 * Called every few seconds from the driver's phone (through Socket.IO).
 * 1. Save location in Redis (used for "drivers near me").
 * 2. If he has an active ride, send his position + ETA to the passenger (live tracking).
 */
export async function updateDriverLocation(userId: string, loc: LatLng, heading?: number | null, speed?: number | null) {
  let vt = (await redis.hget(`driver:loc:${userId}`, 'vt')) as VehicleType | null;
  const [d] = await db
    .select({ isOnline: drivers.isOnline, vehicleType: drivers.vehicleType })
    .from(drivers)
    .where(eq(drivers.userId, userId));
  if (!d) return;
  vt ??= d.vehicleType;

  const [ride] = await db
    .select()
    .from(rides)
    .where(and(eq(rides.driverId, userId), inArray(rides.status, ASSIGNED_RIDE_STATUSES)))
    .limit(1);

  if (d.isOnline && !ride) await setDriverLocation(userId, vt, loc, heading);
  else if (ride) {
    // Busy drivers keep their position stored but are removed from the "free drivers" map.
    await redis.hset(`driver:loc:${userId}`, { lat: loc.lat, lng: loc.lng, heading: heading ?? '', ts: Date.now(), vt });
    await redis.zrem(`drivers:geo:${vt}`, userId);
  }

  // Save to Postgres only every 30 seconds (Redis has the live value).
  if (await redis.set(`driver:persist:${userId}`, '1', 'EX', 30, 'NX')) {
    await db.update(drivers).set({ lastLocation: toXY(loc), lastHeading: heading ?? null, lastSeenAt: new Date() }).where(eq(drivers.userId, userId));
  }

  if (ride) {
    // Before pickup the target is the passenger. During the trip the target is the destination.
    const target = ride.status === 'in_progress' ? fromXY(ride.dropoff) : fromXY(ride.pickup);
    emitToUser(ride.passengerId, Ev.driverLocationUpdate, {
      rideId: ride.id,
      lat: loc.lat,
      lng: loc.lng,
      heading: heading ?? null,
      speed: speed ?? null,
      distanceM: Math.round(distanceM(loc, target)),
      etaSec: estimateEtaSec(loc, target),
      ts: Date.now(),
    });
  }
}

/** Passenger shares GPS during the ride so the driver can see if he is walking to the pickup point. */
export async function forwardPassengerLocation(userId: string, loc: LatLng, heading?: number | null) {
  const [ride] = await db
    .select()
    .from(rides)
    .where(and(eq(rides.passengerId, userId), inArray(rides.status, ['accepted', 'arrived'])))
    .limit(1);
  if (!ride?.driverId) return;
  const pickup = fromXY(ride.pickup);
  emitToUser(ride.driverId, Ev.passengerLocationUpdate, {
    rideId: ride.id,
    lat: loc.lat,
    lng: loc.lng,
    heading: heading ?? null,
    distanceToPickupM: Math.round(distanceM(loc, pickup)),
    ts: Date.now(),
  });
}

/** Cars shown on the passenger's home map. Driver ids are hidden. */
export async function nearbyDriversForMap(center: LatLng, vehicleType?: VehicleType) {
  const types = vehicleType ? [vehicleType] : [...vehicleTypeEnum.enumValues];
  const out: { key: string; vehicleType: VehicleType; lat: number; lng: number; heading: number | null; distanceM: number }[] = [];
  for (const vt of types) {
    const list = await findDriversNear(vt, center, env.matching.maxRadiusM, 20);
    for (const n of list) {
      const loc = await getDriverLocation(n.driverId);
      out.push({
        key: n.driverId.slice(0, 8),
        vehicleType: vt,
        lat: n.lat,
        lng: n.lng,
        heading: loc?.heading ?? null,
        distanceM: n.distanceM,
      });
    }
  }
  out.sort((a, b) => a.distanceM - b.distanceM);
  const nearest = out[0];
  return { drivers: out.slice(0, 40), nearestEtaSec: nearest ? estimateEtaSec(center, nearest) : null };
}

/* ------------------------------ Money ------------------------------ */

export async function earnings(userId: string) {
  const [d] = await db.select({ balance: drivers.balance }).from(drivers).where(eq(drivers.userId, userId));
  if (!d) throw notFound('Not a driver');

  const startOfDay = new Date();
  startOfDay.setHours(0, 0, 0, 0);
  const startOfWeek = new Date(startOfDay);
  startOfWeek.setDate(startOfWeek.getDate() - ((startOfWeek.getDay() + 6) % 7)); // Monday
  const startOfMonth = new Date(startOfDay.getFullYear(), startOfDay.getMonth(), 1);

  const sum = async (from: Date) => {
    const [r] = await db
      .select({
        rides: sql<number>`count(*)::int`,
        gross: sql<number>`coalesce(sum(${rides.finalFare}), 0)::int`,
        commission: sql<number>`coalesce(sum(${rides.commission}), 0)::int`,
        distanceM: sql<number>`coalesce(sum(${rides.distanceM}), 0)::int`,
      })
      .from(rides)
      .where(and(eq(rides.driverId, userId), eq(rides.status, 'completed'), gte(rides.completedAt, from)));
    return { ...r!, net: r!.gross - r!.commission };
  };

  const transactions = await db
    .select()
    .from(walletTransactions)
    .where(eq(walletTransactions.driverId, userId))
    .orderBy(desc(walletTransactions.createdAt))
    .limit(30);

  return {
    balance: d.balance,
    commissionRate: env.commissionRate,
    today: await sum(startOfDay),
    week: await sum(startOfWeek),
    month: await sum(startOfMonth),
    transactions,
  };
}

/** Demo top-up. In a real app this would go through JazzCash / Easypaisa / card payment. */
export async function topUp(userId: string, amount: number, method: string) {
  const [d] = await db
    .update(drivers)
    .set({ balance: sql`${drivers.balance} + ${amount}` })
    .where(eq(drivers.userId, userId))
    .returning({ balance: drivers.balance });
  if (!d) throw notFound('Not a driver');
  await db.insert(walletTransactions).values({ driverId: userId, amount, type: 'topup', note: `Top up via ${method}` });
  emitToUser(userId, Ev.balanceUpdated, { balance: d.balance });
  return { balance: d.balance };
}

import { redis } from '../../lib/redis.js';
import type { LatLng } from '../../lib/geo.js';
import type { VehicleType } from '../../db/schema.js';
import { env } from '../../config/env.js';

/**
 * Live driver locations are kept in Redis (not in Postgres) because they change every few seconds.
 * Redis GEO commands answer "which drivers are within 3 km?" in microseconds.
 *
 *   drivers:geo:<vehicleType>  -> GEO set of online drivers
 *   driver:loc:<id>            -> hash with lat, lng, heading, ts
 */
const geoKey = (vt: VehicleType) => `drivers:geo:${vt}`;
const locKey = (id: string) => `driver:loc:${id}`;

export type DriverLoc = LatLng & { heading: number | null; ts: number };

export async function setDriverLocation(driverId: string, vt: VehicleType, loc: LatLng, heading?: number | null) {
  const ts = Date.now();
  await redis
    .multi()
    .geoadd(geoKey(vt), loc.lng, loc.lat, driverId)
    .hset(locKey(driverId), { lat: loc.lat, lng: loc.lng, heading: heading ?? '', ts, vt })
    .expire(locKey(driverId), env.matching.driverFreshSec * 10)
    .exec();
}

export async function removeDriver(driverId: string, vt: VehicleType) {
  await redis.multi().zrem(geoKey(vt), driverId).del(locKey(driverId)).exec();
}

export async function getDriverLocation(driverId: string): Promise<DriverLoc | null> {
  const h = await redis.hgetall(locKey(driverId));
  if (!h.lat || !h.lng) return null;
  return { lat: Number(h.lat), lng: Number(h.lng), heading: h.heading ? Number(h.heading) : null, ts: Number(h.ts) };
}

/** Online drivers of one vehicle type inside a circle, nearest first. */
export async function findDriversNear(vt: VehicleType, center: LatLng, radiusM: number, limit = 50) {
  const res = (await redis.geosearch(
    geoKey(vt),
    'FROMLONLAT',
    center.lng,
    center.lat,
    'BYRADIUS',
    radiusM,
    'm',
    'ASC',
    'COUNT',
    limit,
    'WITHDIST',
    'WITHCOORD',
  )) as [string, string, [string, string]][];

  const now = Date.now();
  const out: { driverId: string; distanceM: number; lat: number; lng: number }[] = [];
  for (const [driverId, dist, [lng, lat]] of res) {
    const ts = Number(await redis.hget(locKey(driverId), 'ts'));
    // Remove drivers whose GPS is old (app closed, no internet...)
    if (!ts || now - ts > env.matching.driverFreshSec * 1000) {
      await redis.zrem(geoKey(vt), driverId);
      continue;
    }
    out.push({ driverId, distanceM: Math.round(Number(dist)), lat: Number(lat), lng: Number(lng) });
  }
  return out;
}

/** After a ride ends, put the driver back on the "free drivers" map at his last position. */
export async function markDriverFree(driverId: string, isOnline: boolean) {
  const h = await redis.hgetall(locKey(driverId));
  if (!isOnline || !h.lat || !h.lng || !h.vt) return;
  await redis.geoadd(geoKey(h.vt as VehicleType), Number(h.lng), Number(h.lat), driverId);
}

import crypto from 'node:crypto';
import { Router } from 'express';
import { eq } from 'drizzle-orm';
import { env } from '../../config/env.js';
import { db } from '../../db/client.js';
import { drivers, rides, users } from '../../db/schema.js';
import { forbidden, notFound } from '../../lib/errors.js';
import { fromXY } from '../../lib/geo.js';
import { requireAuth, userId } from '../../middleware/auth.js';
import { getDriverLocation } from '../drivers/location.store.js';

/**
 * "Share my trip": family can follow the ride live in any web browser, without the app.
 * The link has a signature so nobody can guess links of other rides.
 */
const sign = (rideId: string) => crypto.createHmac('sha256', env.jwt.refreshSecret).update(`share:${rideId}`).digest('base64url').slice(0, 22);

export function shareUrl(rideId: string) {
  return `${env.publicUrl}/t/${rideId}/${sign(rideId)}`;
}

export const shareApiRouter = Router();

/** App asks for the link of its ride. */
shareApiRouter.get('/rides/:id/share-link', requireAuth, async (req, res) => {
  const [r] = await db.select({ p: rides.passengerId, d: rides.driverId }).from(rides).where(eq(rides.id, String(req.params.id)));
  if (!r) throw notFound('Ride not found');
  if (r.p !== userId(req) && r.d !== userId(req)) throw forbidden();
  res.json({ url: shareUrl(String(req.params.id)) });
});

/** Public data for the web page (no login, only with a valid signature). */
shareApiRouter.get('/share/:id/:sig', async (req, res) => {
  const id = String(req.params.id);
  if (!/^[0-9a-f-]{36}$/.test(id) || req.params.sig !== sign(id)) throw notFound('Link is not valid');
  const [row] = await db.select({ r: rides, p: users }).from(rides).innerJoin(users, eq(users.id, rides.passengerId)).where(eq(rides.id, id));
  if (!row) throw notFound('Link is not valid');
  const { r } = row;
  let driver = null;
  let car = null;
  if (r.driverId) {
    const [d] = await db.select({ u: users, d: drivers }).from(drivers).innerJoin(users, eq(users.id, drivers.userId)).where(eq(drivers.userId, r.driverId));
    if (d) {
      driver = {
        name: d.u.name,
        vehicle: `${d.d.vehicleColor} ${d.d.vehicleMake} ${d.d.vehicleModel}`,
        plateNumber: d.d.plateNumber,
        rating: Math.round(d.d.rating * 10) / 10,
      };
    }
    // Live position only while the ride is active.
    if (['accepted', 'arrived', 'in_progress'].includes(r.status)) car = await getDriverLocation(r.driverId);
  }
  res.json({
    status: r.status,
    passengerName: row.p.name?.split(' ')[0] ?? 'Passenger',
    pickup: { ...fromXY(r.pickup), address: r.pickupAddress },
    dropoff: { ...fromXY(r.dropoff), address: r.dropoffAddress },
    routePolyline: r.routePolyline,
    driver,
    car,
    updatedAt: new Date().toISOString(),
  });
});

import { Router } from 'express';
import { desc, eq, ilike, or, sql } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../../db/client.js';
import { drivers, refreshTokens, rides, sosAlerts, supportTickets, users } from '../../db/schema.js';
import { sendPush } from '../../lib/push.js';
import { notFound } from '../../lib/errors.js';
import { requireAdmin } from '../../middleware/auth.js';
import { parse } from '../../middleware/validate.js';
import { removeDriver } from '../drivers/location.store.js';
import { zUuid } from '../schemas.js';

/** Small admin API used by the web page at /admin. */
export const adminRouter = Router();
adminRouter.use(requireAdmin);

adminRouter.get('/stats', async (_req, res) => {
  const [r] = await db.execute<Record<string, number>>(sql`
    select
      (select count(*)::int from users) as users,
      (select count(*)::int from drivers where status = 'approved') as drivers,
      (select count(*)::int from drivers where status = 'pending') as pending_drivers,
      (select count(*)::int from drivers where is_online) as online_drivers,
      (select count(*)::int from rides where status in ('searching','accepted','arrived','in_progress')) as active_rides,
      (select count(*)::int from rides where status = 'completed') as completed_rides,
      (select coalesce(sum(commission),0)::int from rides where status = 'completed') as total_commission,
      (select count(*)::int from sos_alerts where not resolved) as open_sos,
      (select count(*)::int from support_tickets where status = 'open') as open_tickets
  `).then((x) => x.rows);
  res.json(r);
});

adminRouter.get('/drivers', async (req, res) => {
  const { status } = parse(z.object({ status: z.enum(['pending', 'approved', 'rejected', 'blocked']).optional() }), req.query);
  const rows = await db
    .select({ d: drivers, u: users })
    .from(drivers)
    .innerJoin(users, eq(users.id, drivers.userId))
    .where(status ? eq(drivers.status, status) : undefined)
    .orderBy(desc(drivers.createdAt))
    .limit(200);
  res.json(
    rows.map(({ d, u }) => ({
      id: u.id,
      name: u.name,
      phone: u.phone,
      status: d.status,
      cnicNumber: d.cnicNumber,
      licenseNumber: d.licenseNumber,
      vehicle: `${d.vehicleColor} ${d.vehicleMake} ${d.vehicleModel} (${d.vehicleType}) ${d.plateNumber}`,
      services: d.services,
      docs: d.docs,
      rating: d.rating,
      balance: d.balance,
      isOnline: d.isOnline,
      createdAt: d.createdAt,
    })),
  );
});

adminRouter.post('/drivers/:id/:action', async (req, res) => {
  const id = parse(zUuid, req.params.id);
  const action = parse(z.enum(['approve', 'reject', 'block']), req.params.action);
  const { reason } = parse(z.object({ reason: z.string().max(200).optional() }), req.body ?? {});
  const status = action === 'approve' ? 'approved' : action === 'reject' ? 'rejected' : 'blocked';
  const [d] = await db
    .update(drivers)
    .set({ status, approvedAt: status === 'approved' ? new Date() : null, rejectionReason: reason ?? null, ...(status !== 'approved' ? { isOnline: false } : {}) })
    .where(eq(drivers.userId, id))
    .returning();
  if (!d) throw notFound('Driver not found');
  if (status !== 'approved') await removeDriver(id, d.vehicleType);
  res.json({ ok: true, status });
});

adminRouter.get('/rides', async (_req, res) => {
  const rows = await db.select().from(rides).orderBy(desc(rides.createdAt)).limit(100);
  res.json(
    rows.map((r) => ({
      id: r.id,
      status: r.status,
      serviceType: r.serviceType,
      vehicleType: r.vehicleType,
      from: r.pickupAddress,
      to: r.dropoffAddress,
      offeredFare: r.offeredFare,
      finalFare: r.finalFare,
      createdAt: r.createdAt,
    })),
  );
});

adminRouter.get('/sos', async (_req, res) => {
  res.json(await db.select().from(sosAlerts).orderBy(desc(sosAlerts.createdAt)).limit(50));
});

adminRouter.post('/sos/:id/resolve', async (req, res) => {
  await db.update(sosAlerts).set({ resolved: true }).where(eq(sosAlerts.id, parse(zUuid, req.params.id)));
  res.json({ ok: true });
});

/* ---------------- Support tickets ---------------- */

adminRouter.get('/tickets', async (req, res) => {
  const { status } = parse(z.object({ status: z.enum(['open', 'answered', 'closed']).optional() }), req.query);
  const rows = await db
    .select({ t: supportTickets, u: users })
    .from(supportTickets)
    .innerJoin(users, eq(users.id, supportTickets.userId))
    .where(status ? eq(supportTickets.status, status) : undefined)
    .orderBy(desc(supportTickets.createdAt))
    .limit(200);
  res.json(rows.map(({ t, u }) => ({ ...t, userName: u.name, userPhone: u.phone })));
});

adminRouter.post('/tickets/:id/reply', async (req, res) => {
  const id = parse(zUuid, req.params.id);
  const { reply, close } = parse(z.object({ reply: z.string().trim().min(2).max(2000), close: z.boolean().default(false) }), req.body);
  const [t] = await db
    .update(supportTickets)
    .set({ adminReply: reply, status: close ? 'closed' : 'answered', updatedAt: new Date() })
    .where(eq(supportTickets.id, id))
    .returning();
  if (!t) throw notFound('Ticket not found');
  sendPush(t.userId, { title: 'Support replied to your request', body: reply.slice(0, 120), route: '/support' });
  res.json(t);
});

/* ---------------- Users ---------------- */

adminRouter.get('/users', async (req, res) => {
  const { q } = parse(z.object({ q: z.string().max(60).optional() }), req.query);
  const rows = await db
    .select()
    .from(users)
    .where(q ? or(ilike(users.name, `%${q}%`), ilike(users.phone, `%${q}%`)) : undefined)
    .orderBy(desc(users.createdAt))
    .limit(200);
  res.json(rows.map((u) => ({ id: u.id, name: u.name, phone: u.phone, rating: u.rating, ratingCount: u.ratingCount, isBlocked: u.isBlocked, createdAt: u.createdAt })));
});

adminRouter.post('/users/:id/:action', async (req, res) => {
  const id = parse(zUuid, req.params.id);
  const action = parse(z.enum(['block', 'unblock']), req.params.action);
  const [u] = await db.update(users).set({ isBlocked: action === 'block' }).where(eq(users.id, id)).returning();
  if (!u) throw notFound('User not found');
  // Blocked users are logged out everywhere.
  if (action === 'block') await db.update(refreshTokens).set({ revokedAt: new Date() }).where(eq(refreshTokens.userId, id));
  res.json({ ok: true, isBlocked: u.isBlocked });
});

import { Router } from 'express';
import { and, desc, eq } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../../db/client.js';
import { rides, supportTickets, ticketCategoryEnum } from '../../db/schema.js';
import { forbidden } from '../../lib/errors.js';
import { requireAuth, userId } from '../../middleware/auth.js';
import { parse } from '../../middleware/validate.js';
import { zUuid } from '../schemas.js';

/** Help center: "Report a problem", "I lost an item", account questions. */
export const supportRouter = Router();
supportRouter.use(requireAuth);

supportRouter.get('/tickets', async (req, res) => {
  const rows = await db
    .select()
    .from(supportTickets)
    .where(eq(supportTickets.userId, userId(req)))
    .orderBy(desc(supportTickets.createdAt))
    .limit(50);
  res.json(rows);
});

supportRouter.post('/tickets', async (req, res) => {
  const b = parse(
    z.object({
      category: z.enum(ticketCategoryEnum.enumValues),
      message: z.string().trim().min(10, 'Please write at least 10 characters').max(2000),
      rideId: zUuid.optional(),
    }),
    req.body,
  );
  const uid = userId(req);
  if (b.rideId) {
    // Only for your own rides
    const [r] = await db.select({ p: rides.passengerId, d: rides.driverId }).from(rides).where(eq(rides.id, b.rideId));
    if (!r || (r.p !== uid && r.d !== uid)) throw forbidden('This is not your ride');
  }
  const [t] = await db.insert(supportTickets).values({ userId: uid, rideId: b.rideId, category: b.category, message: b.message }).returning();
  res.status(201).json(t);
});

supportRouter.post('/tickets/:id/close', async (req, res) => {
  await db
    .update(supportTickets)
    .set({ status: 'closed', updatedAt: new Date() })
    .where(and(eq(supportTickets.id, parse(zUuid, req.params.id)), eq(supportTickets.userId, userId(req))));
  res.json({ ok: true });
});

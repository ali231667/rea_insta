import { Router } from 'express';
import { and, desc, eq } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../../db/client.js';
import { savedPlaces } from '../../db/schema.js';
import { fromXY, toXY } from '../../lib/geo.js';
import { requireAuth, userId } from '../../middleware/auth.js';
import { parse } from '../../middleware/validate.js';
import { zLat, zLng, zUuid } from '../schemas.js';

/** Saved places: Home, Work and favourites. */
export const placesRouter = Router();
placesRouter.use(requireAuth);

const dto = (p: typeof savedPlaces.$inferSelect) => ({ id: p.id, label: p.label, name: p.name, address: p.address, ...fromXY(p.location) });

placesRouter.get('/', async (req, res) => {
  const rows = await db.select().from(savedPlaces).where(eq(savedPlaces.userId, userId(req))).orderBy(desc(savedPlaces.createdAt));
  res.json(rows.map(dto));
});

placesRouter.post('/', async (req, res) => {
  const b = parse(
    z.object({ label: z.enum(['home', 'work', 'other']), name: z.string().trim().min(1).max(60), address: z.string().min(1).max(300), lat: zLat, lng: zLng }),
    req.body,
  );
  const uid = userId(req);
  // Only one Home and one Work.
  if (b.label !== 'other') await db.delete(savedPlaces).where(and(eq(savedPlaces.userId, uid), eq(savedPlaces.label, b.label)));
  const [p] = await db
    .insert(savedPlaces)
    .values({ userId: uid, label: b.label, name: b.name, address: b.address, location: toXY(b) })
    .returning();
  res.status(201).json(dto(p!));
});

placesRouter.delete('/:id', async (req, res) => {
  await db.delete(savedPlaces).where(and(eq(savedPlaces.id, parse(zUuid, req.params.id)), eq(savedPlaces.userId, userId(req))));
  res.json({ ok: true });
});

import { Router } from 'express';
import { eq } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../../db/client.js';
import { refreshTokens, users } from '../../db/schema.js';
import { notFound } from '../../lib/errors.js';
import { requireAuth, userId } from '../../middleware/auth.js';
import { fileUrl, upload } from '../../middleware/upload.js';
import { parse } from '../../middleware/validate.js';
import { getDriverProfile } from '../drivers/drivers.service.js';

export const usersRouter = Router();
usersRouter.use(requireAuth);

async function me(id: string) {
  const [u] = await db.select().from(users).where(eq(users.id, id));
  if (!u) throw notFound('User not found');
  return {
    user: {
      id: u.id,
      phone: u.phone,
      name: u.name,
      email: u.email,
      photoUrl: u.photoUrl,
      language: u.language,
      rating: Math.round(u.rating * 100) / 100,
      ratingCount: u.ratingCount,
      createdAt: u.createdAt,
    },
    driver: await getDriverProfile(id),
  };
}

usersRouter.get('/me', async (req, res) => {
  res.json(await me(userId(req)));
});

usersRouter.patch('/me', async (req, res) => {
  const body = parse(
    z.object({
      name: z.string().trim().min(2).max(60).optional(),
      email: z.email().optional().or(z.literal('')),
      language: z.enum(['en', 'ur']).optional(),
      fcmToken: z.string().max(500).optional(),
    }),
    req.body,
  );
  await db
    .update(users)
    .set({ ...body, email: body.email === '' ? null : body.email, fcmToken: body.fcmToken === '' ? null : body.fcmToken, updatedAt: new Date() })
    .where(eq(users.id, userId(req)));
  res.json(await me(userId(req)));
});

usersRouter.post('/me/photo', upload.single('photo'), async (req, res) => {
  await db.update(users).set({ photoUrl: fileUrl(req.file), updatedAt: new Date() }).where(eq(users.id, userId(req)));
  res.json(await me(userId(req)));
});

/** Delete account: we keep ride history for safety reports but remove personal data. */
usersRouter.delete('/me', async (req, res) => {
  const id = userId(req);
  await db
    .update(users)
    .set({ phone: `deleted:${id}`, name: 'Deleted user', email: null, photoUrl: null, fcmToken: null, isBlocked: true })
    .where(eq(users.id, id));
  await db.update(refreshTokens).set({ revokedAt: new Date() }).where(eq(refreshTokens.userId, id));
  res.json({ ok: true });
});

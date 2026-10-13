import type { NextFunction, Request, Response } from 'express';
import { eq } from 'drizzle-orm';
import { db } from '../db/client.js';
import { drivers } from '../db/schema.js';
import { env } from '../config/env.js';
import { forbidden, unauthorized } from '../lib/errors.js';
import { verifyAccessToken } from '../lib/jwt.js';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      auth?: { userId: string; phone: string };
    }
  }
}

/** Checks the "Authorization: Bearer <token>" header. */
export function requireAuth(req: Request, _res: Response, next: NextFunction) {
  const header = req.headers.authorization ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return next(unauthorized());
  try {
    const p = verifyAccessToken(token);
    req.auth = { userId: p.sub, phone: p.phone };
    next();
  } catch {
    next(unauthorized('Session expired', 'token_expired'));
  }
}

/** Returns the logged-in user id (use after requireAuth). */
export function userId(req: Request): string {
  if (!req.auth) throw unauthorized();
  return req.auth.userId;
}

/** Only approved drivers can pass. */
export async function requireApprovedDriver(req: Request, _res: Response, next: NextFunction) {
  const [driver] = await db.select({ status: drivers.status }).from(drivers).where(eq(drivers.userId, userId(req)));
  if (!driver) return next(forbidden('Register as a driver first', 'not_driver'));
  if (driver.status !== 'approved') return next(forbidden('Your driver account is not approved yet', 'driver_not_approved'));
  next();
}

/** Admin panel uses a simple key in the "x-admin-key" header. */
export function requireAdmin(req: Request, _res: Response, next: NextFunction) {
  if (req.headers['x-admin-key'] !== env.adminKey) return next(forbidden('Wrong admin key'));
  next();
}

import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';

export type AccessPayload = { sub: string; phone: string };

export function signAccessToken(payload: AccessPayload): string {
  return jwt.sign(payload, env.jwt.accessSecret, { expiresIn: env.jwt.accessTtlSec });
}

export function verifyAccessToken(token: string): AccessPayload {
  const p = jwt.verify(token, env.jwt.accessSecret) as jwt.JwtPayload;
  return { sub: String(p.sub), phone: String(p.phone) };
}

/** Refresh tokens are long random strings. We only store their SHA-256 hash. */
export const newRefreshToken = () => crypto.randomBytes(48).toString('base64url');
export const hashToken = (t: string) => crypto.createHmac('sha256', env.jwt.refreshSecret).update(t).digest('hex');

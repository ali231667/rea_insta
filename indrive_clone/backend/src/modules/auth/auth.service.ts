import crypto from 'node:crypto';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { env } from '../../config/env.js';
import { db } from '../../db/client.js';
import { drivers, refreshTokens, users, type User } from '../../db/schema.js';
import { AppError, badRequest, unauthorized } from '../../lib/errors.js';
import { hashToken, newRefreshToken, signAccessToken } from '../../lib/jwt.js';
import { redis } from '../../lib/redis.js';
import { sendSms } from './sms.js';

const OTP_TTL_SEC = 5 * 60;
// Wait time before a new SMS can be sent (short in development).
const OTP_COOLDOWN_SEC = env.devOtp ? 10 : 60;
const OTP_MAX_ATTEMPTS = 5;

/**
 * Pakistani mobile numbers: 03001234567, 3001234567, +923001234567, 923001234567
 * are all changed to the international format +923001234567.
 */
export function normalizePkPhone(input: string): string {
  const digits = input.replace(/[^\d+]/g, '');
  let local: string | null = null;
  if (/^\+923\d{9}$/.test(digits)) local = digits.slice(3);
  else if (/^923\d{9}$/.test(digits)) local = digits.slice(2);
  else if (/^03\d{9}$/.test(digits)) local = digits.slice(1);
  else if (/^3\d{9}$/.test(digits)) local = digits;
  if (!local) throw badRequest('Enter a valid Pakistani mobile number like 03001234567', 'invalid_phone');
  return `+92${local}`;
}

const otpHash = (phone: string, code: string) => crypto.createHash('sha256').update(`${phone}:${code}:${env.jwt.accessSecret}`).digest('hex');

export async function requestOtp(rawPhone: string) {
  const phone = normalizePkPhone(rawPhone);
  // Do not send a new SMS more than once per minute.
  const ok = await redis.set(`otp:cool:${phone}`, '1', 'EX', OTP_COOLDOWN_SEC, 'NX');
  if (!ok) {
    const ttl = await redis.ttl(`otp:cool:${phone}`);
    throw new AppError(429, 'otp_cooldown', `Please wait ${ttl} seconds before asking for a new code`);
  }
  const code = String(crypto.randomInt(0, 10_000)).padStart(4, '0');
  await redis.set(`otp:${phone}`, JSON.stringify({ hash: otpHash(phone, code), attempts: 0 }), 'EX', OTP_TTL_SEC);
  await sendSms(phone, `Your InDrive Clone code is ${code}. Do not share it with anyone.`);
  return { phone, expiresInSec: OTP_TTL_SEC, resendInSec: OTP_COOLDOWN_SEC, ...(env.devOtp ? { devCode: code } : {}) };
}

async function issueTokens(user: User) {
  const refreshToken = newRefreshToken();
  await db.insert(refreshTokens).values({
    userId: user.id,
    tokenHash: hashToken(refreshToken),
    expiresAt: new Date(Date.now() + env.jwt.refreshTtlSec * 1000),
  });
  return { accessToken: signAccessToken({ sub: user.id, phone: user.phone }), refreshToken, expiresInSec: env.jwt.accessTtlSec };
}

export async function verifyOtp(rawPhone: string, code: string) {
  const phone = normalizePkPhone(rawPhone);
  const key = `otp:${phone}`;
  const raw = await redis.get(key);
  if (!raw) throw badRequest('Code expired. Please ask for a new code.', 'otp_expired');
  const saved = JSON.parse(raw) as { hash: string; attempts: number };
  if (saved.attempts >= OTP_MAX_ATTEMPTS) {
    await redis.del(key);
    throw badRequest('Too many wrong tries. Please ask for a new code.', 'otp_locked');
  }
  if (saved.hash !== otpHash(phone, code)) {
    saved.attempts++;
    await redis.set(key, JSON.stringify(saved), 'KEEPTTL');
    throw badRequest('Wrong code', 'otp_wrong');
  }
  await redis.del(key, `otp:cool:${phone}`);

  let [user] = await db.select().from(users).where(eq(users.phone, phone));
  const isNewUser = !user || !user.name;
  if (!user) [user] = await db.insert(users).values({ phone }).returning();
  if (user!.isBlocked) throw new AppError(403, 'blocked', 'Your account is blocked. Contact support.');

  const [driver] = await db.select({ status: drivers.status }).from(drivers).where(eq(drivers.userId, user!.id));
  return { ...(await issueTokens(user!)), isNewUser, userId: user!.id, driverStatus: driver?.status ?? null };
}

/** Swap an old refresh token for a new pair (the old one stops working = "rotation"). */
export async function refresh(token: string) {
  const [row] = await db
    .select()
    .from(refreshTokens)
    .where(and(eq(refreshTokens.tokenHash, hashToken(token)), isNull(refreshTokens.revokedAt), gt(refreshTokens.expiresAt, new Date())));
  if (!row) throw unauthorized('Session ended. Please log in again.', 'refresh_invalid');
  await db.update(refreshTokens).set({ revokedAt: new Date() }).where(eq(refreshTokens.id, row.id));
  const [user] = await db.select().from(users).where(eq(users.id, row.userId));
  if (!user || user.isBlocked) throw unauthorized();
  return issueTokens(user);
}

export async function logout(token: string) {
  await db.update(refreshTokens).set({ revokedAt: new Date() }).where(eq(refreshTokens.tokenHash, hashToken(token)));
}

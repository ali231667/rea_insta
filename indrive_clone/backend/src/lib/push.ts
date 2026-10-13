import fs from 'node:fs';
import { eq } from 'drizzle-orm';
import { cert, initializeApp, type App } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { env } from '../config/env.js';
import { db } from '../db/client.js';
import { users } from '../db/schema.js';
import { logger } from './logger.js';

/**
 * Push notifications with Firebase Cloud Messaging (FCM).
 * They reach the phone even when the app is closed (e.g. "Your driver has arrived").
 *
 * Turned on only when FIREBASE_SERVICE_ACCOUNT (path to the JSON key file)
 * or FIREBASE_SERVICE_ACCOUNT_JSON (the JSON text) is set. Otherwise pushes are skipped.
 */
let app: App | null = null;
let initTried = false;

function firebase(): App | null {
  if (initTried) return app;
  initTried = true;
  try {
    const raw = env.firebase.serviceAccountJson ?? (env.firebase.serviceAccountPath ? fs.readFileSync(env.firebase.serviceAccountPath, 'utf8') : null);
    if (!raw) return null;
    app = initializeApp({ credential: cert(JSON.parse(raw)) }, 'push');
    logger.info('🔔 Firebase push notifications are ON');
  } catch (err) {
    logger.error({ err }, 'Firebase init failed, push notifications are OFF');
  }
  return app;
}

export const pushEnabled = () => firebase() !== null;

export type Push = {
  title: string;
  body: string;
  /** Screen to open when the user taps the notification (e.g. "/ride"). */
  route?: string;
  data?: Record<string, string>;
};

/** Sends a push to one user. Never throws (a failed push must not break the ride flow). */
export function sendPush(userId: string, push: Push): void {
  const a = firebase();
  if (!a) return;
  void (async () => {
    const [u] = await db.select({ token: users.fcmToken }).from(users).where(eq(users.id, userId));
    if (!u?.token) return;
    try {
      await getMessaging(a).send({
        token: u.token,
        notification: { title: push.title, body: push.body },
        data: { ...(push.data ?? {}), ...(push.route ? { route: push.route } : {}) },
        android: { priority: 'high', notification: { channelId: 'rides', sound: 'default' } },
        apns: { payload: { aps: { sound: 'default' } } },
      });
    } catch (err) {
      const code = (err as { code?: string }).code;
      // The app was uninstalled or the token changed: forget the old token.
      if (code === 'messaging/registration-token-not-registered' || code === 'messaging/invalid-registration-token') {
        await db.update(users).set({ fcmToken: null }).where(eq(users.id, userId));
      } else {
        logger.warn({ err: (err as Error).message, userId }, 'Push failed');
      }
    }
  })().catch((err) => logger.warn({ err }, 'Push failed'));
}

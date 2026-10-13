import 'dotenv/config';
import { z } from 'zod';

/** "true" / "1" / "yes" -> true, anything else -> false */
const bool = (def: 'true' | 'false') =>
  z
    .string()
    .default(def)
    .transform((v) => ['1', 'true', 'yes'].includes(v.toLowerCase()));

const schema = z.object({
  PORT: z.coerce.number().default(4000),
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  // On Render this is filled automatically from RENDER_EXTERNAL_URL.
  PUBLIC_URL: z.string().default(process.env.RENDER_EXTERNAL_URL ?? 'http://localhost:4000'),

  DATABASE_URL: z.string().default('postgres://postgres:postgres@localhost:5432/indrive'),
  REDIS_URL: z.string().default('redis://localhost:6379'),

  JWT_ACCESS_SECRET: z.string().min(16).default('dev-access-secret-change-me'),
  JWT_REFRESH_SECRET: z.string().min(16).default('dev-refresh-secret-change-me'),

  DEV_OTP: bool('true'),
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_FROM: z.string().optional(),

  AUTO_APPROVE_DRIVERS: bool('true'),
  ADMIN_KEY: z.string().default('admin123'),

  MIN_APP_VERSION: z.string().default('1.0.0'),
  LATEST_APP_VERSION: z.string().default('1.0.0'),
  STORE_URL: z.string().default('https://play.google.com/store'),
  MAINTENANCE: bool('false'),
  MAINTENANCE_MESSAGE: z.string().default('We are improving the service. Please try again soon.'),

  FIREBASE_SERVICE_ACCOUNT: z.string().optional(),
  FIREBASE_SERVICE_ACCOUNT_JSON: z.string().optional(),

  GOOGLE_MAPS_API_KEY: z.string().optional(),
  OSRM_URL: z.string().default('https://router.project-osrm.org'),
  NOMINATIM_URL: z.string().default('https://nominatim.openstreetmap.org'),

  INITIAL_RADIUS_M: z.coerce.number().default(3000),
  RADIUS_STEP_M: z.coerce.number().default(2000),
  MAX_RADIUS_M: z.coerce.number().default(7000),
  EXPAND_EVERY_SEC: z.coerce.number().default(30),
  REQUEST_TTL_SEC: z.coerce.number().default(300),
  OFFER_TTL_SEC: z.coerce.number().default(45),
  COMMISSION_RATE: z.coerce.number().min(0).max(1).default(0.1),
});

const parsed = schema.safeParse(process.env);
if (!parsed.success) {
  console.error('Invalid environment variables:', z.treeifyError(parsed.error));
  process.exit(1);
}
const e = parsed.data;

export const env = {
  port: e.PORT,
  nodeEnv: e.NODE_ENV,
  isProd: e.NODE_ENV === 'production',
  publicUrl: e.PUBLIC_URL.replace(/\/$/, ''),
  databaseUrl: e.DATABASE_URL,
  redisUrl: e.REDIS_URL,
  jwt: {
    accessSecret: e.JWT_ACCESS_SECRET,
    refreshSecret: e.JWT_REFRESH_SECRET,
    accessTtlSec: 15 * 60, // 15 minutes
    refreshTtlSec: 60 * 60 * 24 * 60, // 60 days
  },
  devOtp: e.DEV_OTP,
  twilio: { sid: e.TWILIO_ACCOUNT_SID, token: e.TWILIO_AUTH_TOKEN, from: e.TWILIO_FROM },
  firebase: {
    serviceAccountPath: e.FIREBASE_SERVICE_ACCOUNT || undefined,
    serviceAccountJson: e.FIREBASE_SERVICE_ACCOUNT_JSON || undefined,
  },
  autoApproveDrivers: e.AUTO_APPROVE_DRIVERS,
  adminKey: e.ADMIN_KEY,
  app: {
    minVersion: e.MIN_APP_VERSION,
    latestVersion: e.LATEST_APP_VERSION,
    storeUrl: e.STORE_URL,
    maintenance: e.MAINTENANCE,
    maintenanceMessage: e.MAINTENANCE_MESSAGE,
  },
  maps: {
    googleKey: e.GOOGLE_MAPS_API_KEY || undefined,
    osrmUrl: e.OSRM_URL.replace(/\/$/, ''),
    nominatimUrl: e.NOMINATIM_URL.replace(/\/$/, ''),
  },

  /** Rules used to find drivers. This is the heart of the InDrive flow. */
  matching: {
    initialRadiusM: e.INITIAL_RADIUS_M, // first circle around pickup (2-3 km like InDrive)
    radiusStepM: e.RADIUS_STEP_M, // grow the circle by this much when nobody answers
    maxRadiusM: e.MAX_RADIUS_M, // never search further than this (city rides)
    expandEverySec: e.EXPAND_EVERY_SEC,
    requestTtlSec: e.REQUEST_TTL_SEC, // request closes if no driver is chosen
    offerTtlSec: e.OFFER_TTL_SEC, // a driver's offer is valid this long
    intercityRadiusM: 25_000, // planned city-to-city trips reach drivers further away
    intercityTtlSec: 60 * 60,
    driverFreshSec: 120, // driver GPS older than this = offline
  },
  commissionRate: e.COMMISSION_RATE,
  driverStartBalance: 500, // PKR bonus for new drivers
};

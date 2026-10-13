import 'dotenv/config';

const bool = (v, def = false) => (v === undefined || v === '' ? def : ['1', 'true', 'yes'].includes(String(v).toLowerCase()));
const num = (v, def) => (v === undefined || v === '' || Number.isNaN(Number(v)) ? def : Number(v));

export const config = {
  port: num(process.env.PORT, 4000),
  env: process.env.NODE_ENV || 'development',
  databaseUrl: process.env.DATABASE_URL || 'postgres://postgres:postgres@localhost:5432/indrive',
  jwtSecret: process.env.JWT_SECRET || 'dev-secret-change-me',
  jwtExpiresIn: '30d',
  devOtp: bool(process.env.DEV_OTP, true),
  autoApproveDrivers: bool(process.env.AUTO_APPROVE_DRIVERS, true),
  adminKey: process.env.ADMIN_KEY || 'admin123',
  osrmUrl: process.env.OSRM_URL || 'https://router.project-osrm.org',
  nominatimUrl: process.env.NOMINATIM_URL || 'https://nominatim.openstreetmap.org',
  twilio: {
    sid: process.env.TWILIO_ACCOUNT_SID,
    token: process.env.TWILIO_AUTH_TOKEN,
    from: process.env.TWILIO_FROM,
  },

  // ---- Matching rules (how InDrive finds drivers) ----
  matching: {
    // First search circle around the pickup point (meters). InDrive starts small (2-3 km)...
    initialRadiusM: num(process.env.INITIAL_RADIUS_M, 3000),
    // ...and makes the circle bigger when nobody answers.
    radiusStepM: num(process.env.RADIUS_STEP_M, 2000),
    maxRadiusM: num(process.env.MAX_RADIUS_M, 7000),
    // Wait this long before making the circle bigger.
    expandEverySec: num(process.env.EXPAND_EVERY_SEC, 30),
    // A city request is closed if nobody is accepted in this time.
    requestTtlSec: num(process.env.REQUEST_TTL_SEC, 300),
    // Intercity requests are planned trips, so drivers further away can see them.
    intercityRadiusM: 25000,
    intercityTtlSec: 60 * 60,
    // A driver's offer is valid for this many seconds.
    offerTtlSec: num(process.env.OFFER_TTL_SEC, 45),
    // A driver is "online" only if his GPS was updated recently.
    driverFreshSec: 120,
  },

  // Commission the platform takes from each completed ride (InDrive takes ~10%).
  commissionRate: num(process.env.COMMISSION_RATE, 0.1),
  // New drivers get some starting balance.
  driverStartBalance: 500,
};

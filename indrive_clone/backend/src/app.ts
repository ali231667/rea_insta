import path from 'node:path';
import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import { pinoHttp } from 'pino-http';
import { logger } from './lib/logger.js';
import { errorHandler, notFoundHandler } from './middleware/error-handler.js';
import { UPLOAD_DIR } from './middleware/upload.js';
import { adminRouter } from './modules/admin/admin.routes.js';
import { authRouter } from './modules/auth/auth.routes.js';
import { driversRouter } from './modules/drivers/drivers.routes.js';
import { mapsRouter } from './modules/maps/maps.routes.js';
import { placesRouter } from './modules/places/places.routes.js';
import { ridesRouter } from './modules/rides/rides.routes.js';
import { SERVICE_VEHICLES, VEHICLE_LABELS } from './modules/rides/fare.js';
import { usersRouter } from './modules/users/users.routes.js';
import { supportRouter } from './modules/support/support.routes.js';
import { shareApiRouter } from './modules/share/share.routes.js';
import { env } from './config/env.js';

export function createApp() {
  const app = express();
  app.set('trust proxy', 1);
  app.use(helmet({ contentSecurityPolicy: false, crossOriginResourcePolicy: { policy: 'cross-origin' } }));
  app.use(cors());
  app.use(express.json({ limit: '1mb' }));
  if (env.nodeEnv !== 'test') app.use(pinoHttp({ logger, autoLogging: { ignore: (req) => req.url === '/health' } }));

  app.get('/health', (_req, res) => {
    res.json({ ok: true, time: new Date().toISOString() });
  });

  /** App settings the Flutter app downloads at start. */
  app.get('/api/v1/config', (_req, res) => {
    res.json({
      currency: 'PKR',
      serviceVehicles: SERVICE_VEHICLES,
      vehicleLabels: VEHICLE_LABELS,
      offerTtlSec: env.matching.offerTtlSec,
      requestTtlSec: env.matching.requestTtlSec,
      commissionRate: env.commissionRate,
      emergencyNumbers: { police: '15', rescue: '1122', ambulance: '115' },
      supportPhone: '+920000000000',
      // The app shows "Please update" when its version is lower than minAppVersion.
      minAppVersion: env.app.minVersion,
      latestAppVersion: env.app.latestVersion,
      storeUrl: env.app.storeUrl,
      maintenance: env.app.maintenance ? { message: env.app.maintenanceMessage } : null,
      legal: { termsUrl: `${env.publicUrl}/legal/terms`, privacyUrl: `${env.publicUrl}/legal/privacy` },
    });
  });

  const api = express.Router();
  api.use('/auth', authRouter);
  api.use('/users', usersRouter);
  api.use('/drivers', driversRouter);
  api.use('/rides', ridesRouter);
  api.use('/maps', mapsRouter);
  api.use('/places', placesRouter);
  api.use('/admin', adminRouter);
  api.use('/support', supportRouter);
  api.use('/', shareApiRouter);
  app.use('/api/v1', api);

  app.use('/uploads', express.static(UPLOAD_DIR, { maxAge: '7d' }));
  // Terms of Service + Privacy Policy (app stores need public links)
  app.get('/legal/:page', (req, res, next) => {
    if (req.params.page !== 'terms' && req.params.page !== 'privacy') return next();
    res.sendFile(path.resolve(process.cwd(), `src/public/legal/${req.params.page}.html`));
  });

  // Live trip page for family ("Share trip" link)
  app.get('/t/:id/:sig', (_req, res) => {
    res.sendFile(path.resolve(process.cwd(), 'src/public/trip.html'));
  });

  // Admin web page (approve drivers, see rides and SOS alerts)
  app.get('/admin', (_req, res) => {
    res.sendFile(path.resolve(process.cwd(), 'src/public/admin.html'));
  });

  app.use(notFoundHandler);
  app.use(errorHandler);
  return app;
}

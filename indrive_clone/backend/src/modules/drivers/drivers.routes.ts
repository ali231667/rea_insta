import { Router } from 'express';
import { z } from 'zod';
import { requireApprovedDriver, requireAuth, userId } from '../../middleware/auth.js';
import { fileUrl, upload } from '../../middleware/upload.js';
import { parse } from '../../middleware/validate.js';
import { openRequestsForDriver } from '../rides/matching.service.js';
import { zLat, zLng, zService, zVehicle } from '../schemas.js';
import * as svc from './drivers.service.js';

export const driversRouter = Router();
driversRouter.use(requireAuth);

const docFields = ['selfie', 'cnicFront', 'cnicBack', 'license', 'vehicle'] as const;

/** Multipart form: text fields + up to 5 photos. */
driversRouter.post(
  '/register',
  upload.fields(docFields.map((name) => ({ name, maxCount: 1 }))),
  async (req, res) => {
    const body = parse(
      z.object({
        cnicNumber: z.string().regex(/^\d{5}-?\d{7}-?\d$/, 'CNIC must look like 35202-1234567-1'),
        licenseNumber: z.string().trim().min(4).max(30),
        vehicleType: zVehicle,
        vehicleMake: z.string().trim().min(2).max(40),
        vehicleModel: z.string().trim().min(1).max(40),
        vehicleColor: z.string().trim().min(2).max(30),
        vehicleYear: z.coerce.number().int().min(1980).max(new Date().getFullYear() + 1).optional(),
        plateNumber: z.string().trim().min(3).max(15),
        // Sent as "city,courier" from a form
        services: z.preprocess((v) => (typeof v === 'string' ? v.split(',').filter(Boolean) : v), z.array(zService).min(1)),
      }),
      req.body,
    );
    const files = (req.files ?? {}) as Record<string, Express.Multer.File[]>;
    const docs = Object.fromEntries(docFields.filter((f) => files[f]?.[0]).map((f) => [f, fileUrl(files[f]![0])]));
    const cnic = body.cnicNumber.replace(/-/g, '');
    res.status(201).json(
      await svc.registerDriver(userId(req), { ...body, cnicNumber: `${cnic.slice(0, 5)}-${cnic.slice(5, 12)}-${cnic.slice(12)}` }, docs),
    );
  },
);

driversRouter.get('/me', async (req, res) => {
  res.json(await svc.getDriverProfile(userId(req)));
});

driversRouter.patch('/me/services', async (req, res) => {
  const { services } = parse(z.object({ services: z.array(zService).min(1) }), req.body);
  res.json(await svc.updateServices(userId(req), services));
});

driversRouter.post('/me/online', async (req, res) => {
  const body = parse(
    z.object({ online: z.boolean(), lat: zLat.optional(), lng: zLng.optional(), heading: z.number().optional() }),
    req.body,
  );
  const loc = body.lat !== undefined && body.lng !== undefined ? { lat: body.lat, lng: body.lng, heading: body.heading } : undefined;
  res.json(await svc.setOnline(userId(req), body.online, loc));
});

/** Open requests around the driver (the "order feed"). */
driversRouter.get('/me/requests', requireApprovedDriver, async (req, res) => {
  res.json(await openRequestsForDriver(userId(req)));
});

driversRouter.get('/me/earnings', async (req, res) => {
  res.json(await svc.earnings(userId(req)));
});

driversRouter.post('/me/topup', async (req, res) => {
  const { amount, method } = parse(
    z.object({ amount: z.number().int().min(100).max(50_000), method: z.enum(['jazzcash', 'easypaisa', 'card']) }),
    req.body,
  );
  res.json(await svc.topUp(userId(req), amount, method));
});

/** For the passenger home map: cars around me. */
driversRouter.get('/nearby', async (req, res) => {
  const q = parse(z.object({ lat: zLat, lng: zLng, vehicleType: zVehicle.optional() }), req.query);
  res.json(await svc.nearbyDriversForMap({ lat: q.lat, lng: q.lng }, q.vehicleType));
});

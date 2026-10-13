import { Router } from 'express';
import { z } from 'zod';
import { requireApprovedDriver, requireAuth, userId } from '../../middleware/auth.js';
import { parse } from '../../middleware/validate.js';
import { zLatLng, zPoint, zService, zUuid, zVehicle } from '../schemas.js';
import * as svc from './rides.service.js';

export const ridesRouter = Router();
ridesRouter.use(requireAuth);

const id = (raw: unknown) => parse(zUuid, raw);

/* ---------- Passenger ---------- */

/** Price + route for every vehicle type, shown before ordering. */
ridesRouter.post('/estimate', async (req, res) => {
  const b = parse(z.object({ serviceType: zService.default('city'), pickup: zLatLng, dropoff: zLatLng }), req.body);
  res.json(await svc.estimate(b.serviceType, b.pickup, b.dropoff));
});

ridesRouter.post('/', async (req, res) => {
  const b = parse(
    z.object({
      serviceType: zService.default('city'),
      vehicleType: zVehicle,
      pickup: zPoint,
      dropoff: zPoint,
      offeredFare: z.number().int().positive(),
      comment: z.string().trim().max(300).optional(),
      details: z
        .object({
          packageDescription: z.string().max(200).optional(),
          receiverName: z.string().max(60).optional(),
          receiverPhone: z.string().max(20).optional(),
          departureAt: z.string().max(40).optional(),
          seats: z.number().int().min(1).max(8).optional(),
          sharedRide: z.boolean().optional(),
          cargoDescription: z.string().max(200).optional(),
          needLoaders: z.boolean().optional(),
          childSeat: z.boolean().optional(),
          withPet: z.boolean().optional(),
        })
        .optional(),
    }),
    req.body,
  );
  res.status(201).json(await svc.createRide(userId(req), b));
});

ridesRouter.get('/active', async (req, res) => {
  const { role } = parse(z.object({ role: z.enum(['passenger', 'driver']).default('passenger') }), req.query);
  res.json({ ride: await svc.activeRide(userId(req), role) });
});

ridesRouter.get('/history', async (req, res) => {
  const q = parse(
    z.object({
      role: z.enum(['passenger', 'driver']).default('passenger'),
      limit: z.coerce.number().int().min(1).max(50).default(20),
      before: z.coerce.date().optional(),
    }),
    req.query,
  );
  res.json(await svc.history(userId(req), q.role, q.limit, q.before));
});

ridesRouter.get('/recent-places', async (req, res) => {
  res.json(await svc.recentDestinations(userId(req)));
});

ridesRouter.get('/:id', async (req, res) => {
  res.json(await svc.getRideForUser(userId(req), id(req.params.id)));
});

ridesRouter.patch('/:id/fare', async (req, res) => {
  const { offeredFare } = parse(z.object({ offeredFare: z.number().int().positive() }), req.body);
  res.json(await svc.raiseFare(userId(req), id(req.params.id), offeredFare));
});

ridesRouter.post('/:id/offers/:offerId/accept', async (req, res) => {
  res.json(await svc.acceptOffer(userId(req), id(req.params.id), id(req.params.offerId)));
});

ridesRouter.post('/:id/offers/:offerId/decline', async (req, res) => {
  res.json(await svc.declineOffer(userId(req), id(req.params.id), id(req.params.offerId)));
});

ridesRouter.post('/:id/cancel', async (req, res) => {
  const { reason } = parse(z.object({ reason: z.string().trim().min(2).max(200) }), req.body);
  res.json(await svc.cancelRide(userId(req), id(req.params.id), reason));
});

ridesRouter.post('/:id/rate', async (req, res) => {
  const b = parse(z.object({ stars: z.number().int().min(1).max(5), review: z.string().trim().max(500).optional() }), req.body);
  res.json(await svc.rateRide(userId(req), id(req.params.id), b.stars, b.review));
});

ridesRouter.get('/:id/messages', async (req, res) => {
  res.json(await svc.listMessages(userId(req), id(req.params.id)));
});

ridesRouter.post('/:id/messages', async (req, res) => {
  const { body } = parse(z.object({ body: z.string().trim().min(1).max(1000) }), req.body);
  res.status(201).json(await svc.sendMessage(userId(req), id(req.params.id), body));
});

ridesRouter.post('/:id/sos', async (req, res) => {
  const b = parse(z.object({ lat: z.number().optional(), lng: z.number().optional() }), req.body ?? {});
  res.json(await svc.sos(userId(req), id(req.params.id), b.lat !== undefined && b.lng !== undefined ? { lat: b.lat, lng: b.lng } : undefined));
});

/* ---------- Driver ---------- */

ridesRouter.post('/:id/offers', requireApprovedDriver, async (req, res) => {
  const { price } = parse(z.object({ price: z.number().int().positive() }), req.body);
  res.status(201).json(await svc.makeOffer(userId(req), id(req.params.id), price));
});

ridesRouter.post('/:id/arrived', async (req, res) => {
  res.json(await svc.driverArrived(userId(req), id(req.params.id)));
});

ridesRouter.post('/:id/start', async (req, res) => {
  res.json(await svc.startRide(userId(req), id(req.params.id)));
});

ridesRouter.post('/:id/complete', async (req, res) => {
  res.json(await svc.completeRide(userId(req), id(req.params.id)));
});

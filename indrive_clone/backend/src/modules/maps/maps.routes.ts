import { Router } from 'express';
import { z } from 'zod';
import { requireAuth } from '../../middleware/auth.js';
import { parse } from '../../middleware/validate.js';
import { zLat, zLng } from '../schemas.js';
import { getRoute, reverseGeocode, searchPlaces } from './maps.service.js';

/** The app asks the backend for map data, so API keys stay secret on the server. */
export const mapsRouter = Router();
mapsRouter.use(requireAuth);

mapsRouter.get('/search', async (req, res) => {
  const q = parse(z.object({ q: z.string().max(120), lat: zLat.optional(), lng: zLng.optional() }), req.query);
  res.json(await searchPlaces(q.q, q.lat !== undefined && q.lng !== undefined ? { lat: q.lat, lng: q.lng } : undefined));
});

mapsRouter.get('/reverse', async (req, res) => {
  const q = parse(z.object({ lat: zLat, lng: zLng }), req.query);
  res.json(await reverseGeocode(q));
});

mapsRouter.get('/route', async (req, res) => {
  const q = parse(z.object({ fromLat: zLat, fromLng: zLng, toLat: zLat, toLng: zLng }), req.query);
  res.json(await getRoute({ lat: q.fromLat, lng: q.fromLng }, { lat: q.toLat, lng: q.toLng }));
});

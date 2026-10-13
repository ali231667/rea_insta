import type { Server as HttpServer } from 'node:http';
import { createAdapter } from '@socket.io/redis-adapter';
import { Server } from 'socket.io';
import { z } from 'zod';
import { verifyAccessToken } from '../lib/jwt.js';
import { logger } from '../lib/logger.js';
import { createRedis } from '../lib/redis.js';
import { forwardPassengerLocation, updateDriverLocation } from '../modules/drivers/drivers.service.js';
import { setIo, userRoom } from './emitter.js';
import { Ev } from './events.js';

const zLoc = z.object({
  lat: z.number().min(-90).max(90),
  lng: z.number().min(-180).max(180),
  heading: z.number().nullable().optional(),
  speed: z.number().nullable().optional(),
});

/**
 * Realtime connection (WebSocket) between app and server.
 * Used for: new requests, offers, ride status, live driver/passenger location, chat.
 */
export function createSocketServer(http: HttpServer) {
  const io = new Server(http, { cors: { origin: '*' }, pingInterval: 20_000, pingTimeout: 20_000 });

  // Redis adapter: lets you run many backend servers behind a load balancer.
  io.adapter(createAdapter(createRedis(), createRedis()));

  // Only logged-in users can connect. The app sends its access token in "auth.token".
  io.use((socket, next) => {
    try {
      const token = String(socket.handshake.auth?.token ?? '');
      const p = verifyAccessToken(token);
      socket.data.userId = p.sub;
      next();
    } catch {
      next(new Error('unauthorized'));
    }
  });

  io.on('connection', (socket) => {
    const uid = socket.data.userId as string;
    void socket.join(userRoom(uid));
    logger.debug({ uid }, 'socket connected');

    socket.on(Ev.driverLocation, async (raw: unknown, ack?: (r: unknown) => void) => {
      const r = zLoc.safeParse(raw);
      if (!r.success) return ack?.({ ok: false });
      try {
        await updateDriverLocation(uid, r.data, r.data.heading, r.data.speed);
        ack?.({ ok: true });
      } catch (err) {
        logger.error({ err }, 'driver location failed');
        ack?.({ ok: false });
      }
    });

    socket.on(Ev.passengerLocation, async (raw: unknown) => {
      const r = zLoc.safeParse(raw);
      if (!r.success) return;
      await forwardPassengerLocation(uid, r.data, r.data.heading).catch((err) => logger.error({ err }, 'passenger location failed'));
    });
  });

  setIo(io);
  return io;
}

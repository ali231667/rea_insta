import { Redis } from 'ioredis';
import { env } from '../config/env.js';

/** Main Redis connection: OTP codes, live driver locations, caches. */
export const redis = new Redis(env.redisUrl, { maxRetriesPerRequest: null });

/** Creates a new connection (Socket.IO adapter and BullMQ need their own). */
export const createRedis = () => new Redis(env.redisUrl, { maxRetriesPerRequest: null });

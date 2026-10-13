import { Queue, Worker, type Job } from 'bullmq';
import { createRedis } from '../lib/redis.js';
import { logger } from '../lib/logger.js';

/**
 * Timed jobs with BullMQ (stored in Redis, so they survive a server restart):
 *  - expand-search : make the search circle bigger if no driver was chosen yet
 *  - expire-ride   : close the request when its time is over
 *  - expire-offer  : a driver's offer is only valid for ~45 seconds
 */
export type JobData =
  | { type: 'expand-search'; rideId: string }
  | { type: 'expire-ride'; rideId: string }
  | { type: 'expire-offer'; offerId: string };

const QUEUE = 'ride-timers';
let queue: Queue | null = null;

function getQueue() {
  queue ??= new Queue(QUEUE, {
    connection: createRedis(),
    defaultJobOptions: { removeOnComplete: true, removeOnFail: 100, attempts: 3, backoff: { type: 'exponential', delay: 1000 } },
  });
  return queue;
}

export async function scheduleJob(data: JobData, delayMs: number, jobId: string) {
  await getQueue().add(data.type, data, { delay: Math.max(0, delayMs), jobId });
}

export function startWorker(handler: (data: JobData) => Promise<void>) {
  const worker = new Worker<JobData>(QUEUE, (job: Job<JobData>) => handler(job.data), {
    connection: createRedis(),
    concurrency: 10,
  });
  worker.on('failed', (job, err) => logger.error({ err, job: job?.name }, 'Job failed'));
  return worker;
}

export async function closeQueue() {
  await queue?.close();
}

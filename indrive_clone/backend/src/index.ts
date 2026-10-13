import { createServer } from 'node:http';
import { createApp } from './app.js';
import { env } from './config/env.js';
import { pool } from './db/client.js';
import { runMigrations } from './db/migrate.js';
import { closeQueue, startWorker } from './jobs/queue.js';
import { logger } from './lib/logger.js';
import { redis } from './lib/redis.js';
import { handleJob } from './modules/rides/matching.service.js';
import { createSocketServer } from './realtime/socket.js';

async function main() {
  await runMigrations();
  const app = createApp();
  const http = createServer(app);
  const io = createSocketServer(http);
  const worker = startWorker(handleJob);

  http.listen(env.port, '0.0.0.0', () => {
    logger.info(`🚗 InDrive clone API running on http://localhost:${env.port}`);
    logger.info(`   Admin panel: http://localhost:${env.port}/admin`);
    if (env.devOtp) logger.info('   DEV_OTP is on: login codes are printed here');
  });

  const shutdown = async () => {
    logger.info('Shutting down...');
    await io.close();
    await worker.close();
    await closeQueue();
    await pool.end();
    redis.disconnect();
    process.exit(0);
  };
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

main().catch((err) => {
  logger.fatal(err);
  process.exit(1);
});

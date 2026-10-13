import { fork } from 'node:child_process';
import { existsSync } from 'node:fs';
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
    startSimulatedDrivers();
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

/** Optional fake drivers on the server (SIM_DRIVERS=8 SIM_LAT=.. SIM_LNG=..), for demos without a second phone. */
function startSimulatedDrivers() {
  const count = Number(process.env.SIM_DRIVERS ?? 0);
  if (!count || !env.devOtp) return;
  const script = new URL('../scripts/simulate-drivers.js', import.meta.url).pathname;
  if (!existsSync(script)) return logger.warn('Simulator not found (run the built server)');
  const args = ['--server', `http://127.0.0.1:${env.port}`, '--count', String(count)];
  if (process.env.SIM_LAT && process.env.SIM_LNG) args.push('--lat', process.env.SIM_LAT, '--lng', process.env.SIM_LNG);
  else args.push('--city', process.env.SIM_CITY ?? 'lahore');
  fork(script, args);
  logger.info(`Started ${count} simulated drivers`);
}

main().catch((err) => {
  logger.fatal(err);
  process.exit(1);
});

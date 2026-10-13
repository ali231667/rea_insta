import { migrate } from 'drizzle-orm/node-postgres/migrator';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { db, pool } from './client.js';

/** Runs all SQL files in /drizzle that were not run yet. */
export async function runMigrations() {
  const folder = path.resolve(process.cwd(), 'drizzle');
  await migrate(db, { migrationsFolder: folder });
}

// Run directly: npm run db:migrate
if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  runMigrations()
    .then(() => {
      console.log('Migrations done');
      return pool.end();
    })
    .catch((err) => {
      console.error(err);
      process.exit(1);
    });
}

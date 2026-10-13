import type { z } from 'zod';
import { badRequest } from '../lib/errors.js';

/** Checks data with a zod schema. Throws a 400 error with a readable message. */
export function parse<T extends z.ZodType>(schema: T, data: unknown): z.infer<T> {
  const r = schema.safeParse(data);
  if (!r.success) {
    const first = r.error.issues[0];
    const where = first?.path.length ? `${first.path.join('.')}: ` : '';
    throw badRequest(`${where}${first?.message ?? 'Invalid data'}`, 'validation_error');
  }
  return r.data;
}

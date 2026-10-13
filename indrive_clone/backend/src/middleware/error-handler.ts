import type { NextFunction, Request, Response } from 'express';
import multer from 'multer';
import { AppError } from '../lib/errors.js';
import { logger } from '../lib/logger.js';

export function notFoundHandler(req: Request, res: Response) {
  res.status(404).json({ error: { code: 'not_found', message: `No route ${req.method} ${req.path}` } });
}

// Express knows this is an error handler because it has 4 arguments.
export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction) {
  if (err instanceof AppError) {
    return res.status(err.status).json({ error: { code: err.code, message: err.message } });
  }
  if (err instanceof multer.MulterError) {
    return res.status(400).json({ error: { code: 'upload_error', message: err.message } });
  }
  if (err instanceof SyntaxError && 'body' in err) {
    return res.status(400).json({ error: { code: 'bad_json', message: 'Invalid JSON body' } });
  }
  logger.error({ err }, 'Unhandled error');
  res.status(500).json({ error: { code: 'server_error', message: 'Something went wrong' } });
}

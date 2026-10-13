import crypto from 'node:crypto';
import path from 'node:path';
import multer from 'multer';
import { env } from '../config/env.js';
import { badRequest } from '../lib/errors.js';

export const UPLOAD_DIR = path.resolve(process.cwd(), 'uploads');

/** Saves images to /uploads with a random file name. Max 5 MB each. */
export const upload = multer({
  storage: multer.diskStorage({
    destination: UPLOAD_DIR,
    filename: (_req, file, cb) => {
      const ext = path.extname(file.originalname).toLowerCase() || '.jpg';
      cb(null, `${crypto.randomUUID()}${ext}`);
    },
  }),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (/^image\/(jpeg|png|webp|heic|heif)$/.test(file.mimetype) || file.mimetype === 'application/octet-stream') cb(null, true);
    else cb(badRequest('Only images are allowed'));
  },
});

export const fileUrl = (file?: Express.Multer.File) => (file ? `${env.publicUrl}/uploads/${file.filename}` : undefined);

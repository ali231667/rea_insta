import { Router } from 'express';
import { rateLimit } from 'express-rate-limit';
import { z } from 'zod';
import { parse } from '../../middleware/validate.js';
import * as auth from './auth.service.js';

export const authRouter = Router();

// Stop people from trying thousands of codes.
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, limit: 30, standardHeaders: 'draft-8', legacyHeaders: false });

authRouter.post('/otp/request', limiter, async (req, res) => {
  const { phone } = parse(z.object({ phone: z.string().min(7).max(20) }), req.body);
  res.json(await auth.requestOtp(phone));
});

authRouter.post('/otp/verify', limiter, async (req, res) => {
  const { phone, code } = parse(z.object({ phone: z.string(), code: z.string().regex(/^\d{4}$/, 'Code must be 4 digits') }), req.body);
  res.json(await auth.verifyOtp(phone, code));
});

authRouter.post('/refresh', async (req, res) => {
  const { refreshToken } = parse(z.object({ refreshToken: z.string().min(10) }), req.body);
  res.json(await auth.refresh(refreshToken));
});

authRouter.post('/logout', async (req, res) => {
  const { refreshToken } = parse(z.object({ refreshToken: z.string().min(10) }), req.body);
  await auth.logout(refreshToken);
  res.json({ ok: true });
});

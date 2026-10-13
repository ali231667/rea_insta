import { env } from '../../config/env.js';
import { logger } from '../../lib/logger.js';

/** Sends the OTP SMS. In development we only print it in the server log. */
export async function sendSms(to: string, text: string) {
  const { sid, token, from } = env.twilio;
  if (env.devOtp || !sid || !token || !from) {
    logger.info(`📱 SMS to ${to}: ${text}`);
    return;
  }
  const res = await fetch(`https://api.twilio.com/2010-04-01/Accounts/${sid}/Messages.json`, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${Buffer.from(`${sid}:${token}`).toString('base64')}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({ To: to, From: from, Body: text }),
    signal: AbortSignal.timeout(10_000),
  });
  if (!res.ok) throw new Error(`SMS failed: ${res.status} ${await res.text()}`);
}

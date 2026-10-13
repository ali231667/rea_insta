/** An error we expect (bad input, not allowed...). It is sent to the app as JSON. */
export class AppError extends Error {
  constructor(
    public status: number,
    public code: string,
    message: string,
  ) {
    super(message);
  }
}

export const badRequest = (msg: string, code = 'bad_request') => new AppError(400, code, msg);
export const unauthorized = (msg = 'Please log in again', code = 'unauthorized') => new AppError(401, code, msg);
export const forbidden = (msg = 'You are not allowed to do this', code = 'forbidden') => new AppError(403, code, msg);
export const notFound = (msg = 'Not found', code = 'not_found') => new AppError(404, code, msg);
export const conflict = (msg: string, code = 'conflict') => new AppError(409, code, msg);

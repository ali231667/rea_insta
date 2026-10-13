# API reference

Base URL: `http://localhost:4000/api/v1`.
All endpoints except `/auth/*` need the header `Authorization: Bearer <accessToken>`.
Errors look like: `{ "error": { "code": "fare_too_low", "message": "Minimum fare is PKR 250" } }`.

## Auth
| Method | Path | Body | Notes |
|---|---|---|---|
| POST | `/auth/otp/request` | `{ phone }` | Sends a 4-digit code. In dev the answer has `devCode`. |
| POST | `/auth/otp/verify` | `{ phone, code }` | Returns `accessToken` (15 min), `refreshToken` (60 days), `isNewUser`. |
| POST | `/auth/refresh` | `{ refreshToken }` | New token pair. The old refresh token stops working. |
| POST | `/auth/logout` | `{ refreshToken }` | |

## User
| Method | Path | Notes |
|---|---|---|
| GET | `/users/me` | `{ user, driver }` (driver is null if not registered) |
| PATCH | `/users/me` | `{ name?, email?, language?, fcmToken? }` |
| POST | `/users/me/photo` | multipart `photo` |
| DELETE | `/users/me` | Removes personal data |
| GET/POST/DELETE | `/places`, `/places/:id` | Saved places (home, work, other) |

## Maps (the backend calls Google or OpenStreetMap)
| Method | Path |
|---|---|
| GET | `/maps/search?q=&lat=&lng=` |
| GET | `/maps/reverse?lat=&lng=` |
| GET | `/maps/route?fromLat=&fromLng=&toLat=&toLng=` → `{ distanceM, durationS, polyline }` |

## Rides – passenger
| Method | Path | Body |
|---|---|---|
| POST | `/rides/estimate` | `{ serviceType, pickup:{lat,lng}, dropoff:{lat,lng} }` → route + price for every vehicle |
| POST | `/rides` | `{ serviceType, vehicleType, pickup:{lat,lng,address}, dropoff:{…}, offeredFare, comment?, details? }` |
| GET | `/rides/active?role=passenger\|driver` | Current ride (to restore the screen) |
| GET | `/rides/:id` | Ride + passenger + driver + pending offers |
| PATCH | `/rides/:id/fare` | `{ offeredFare }` raise the price |
| POST | `/rides/:id/offers/:offerId/accept` | Choose a driver |
| POST | `/rides/:id/offers/:offerId/decline` | |
| POST | `/rides/:id/cancel` | `{ reason }` (passenger or driver) |
| POST | `/rides/:id/rate` | `{ stars, review? }` (passenger rates driver, driver rates passenger) |
| GET/POST | `/rides/:id/messages` | Chat `{ body }` |
| POST | `/rides/:id/sos` | `{ lat?, lng? }` |
| GET | `/rides/history?role=&before=` | 20 per page |
| GET | `/rides/recent-places` | Last 5 destinations |

## Rides – driver
| Method | Path | Body |
|---|---|---|
| POST | `/drivers/register` | multipart: `cnicNumber, licenseNumber, vehicleType, vehicleMake, vehicleModel, vehicleColor, vehicleYear?, plateNumber, services` + photos `selfie, cnicFront, cnicBack, license, vehicle` |
| GET | `/drivers/me` | Driver profile, balance, status |
| PATCH | `/drivers/me/services` | `{ services: ['city','courier'] }` |
| POST | `/drivers/me/online` | `{ online, lat, lng, heading? }` |
| GET | `/drivers/me/requests` | Open requests around me |
| POST | `/rides/:id/offers` | `{ price }` (≥ passenger price) |
| POST | `/rides/:id/arrived` · `/start` · `/complete` | Trip steps |
| GET | `/drivers/me/earnings` | Balance, today/week/month, wallet history |
| POST | `/drivers/me/topup` | `{ amount, method: jazzcash\|easypaisa\|card }` (demo) |
| GET | `/drivers/nearby?lat=&lng=` | Cars for the passenger map (ids hidden) |

## Admin (header `x-admin-key`)
`GET /admin/stats`, `GET /admin/drivers?status=pending`, `POST /admin/drivers/:id/approve|reject|block`, `GET /admin/rides`, `GET /admin/sos`, `POST /admin/sos/:id/resolve`.
Web page: `http://localhost:4000/admin`.

## Socket.IO events
Connect to `http://localhost:4000` with `auth: { token: accessToken }`.

| Event | Direction | Data |
|---|---|---|
| `driver:location` | driver → server | `{ lat, lng, heading?, speed? }` every 2-3 s |
| `passenger:location` | passenger → server | `{ lat, lng }` during accepted/arrived |
| `ride:request` | server → driver | New request near you |
| `ride:request_updated` | server → driver | `{ rideId, offeredFare }` passenger raised price |
| `ride:request_closed` | server → driver | `{ rideId, reason: taken\|cancelled\|expired }` |
| `offer:rejected` / `offer:expired` | server → driver | `{ offerId, rideId }` |
| `offer:new` | server → passenger | Offer with driver info |
| `offer:updated` | server → passenger | `{ offerId, status }` |
| `ride:search_progress` | server → passenger | `{ radiusM, driversNotified }` |
| `driver:location` | server → passenger | `{ lat, lng, heading, distanceM, etaSec }` |
| `passenger:location` | server → driver | `{ lat, lng, distanceToPickupM }` |
| `ride:updated` | server → both | Full ride after every status change |
| `chat:message` | server → both | New chat message |
| `driver:balance` | server → driver | `{ balance }` |

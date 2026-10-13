# inDrive clone (student project)

A ride-hailing app like **InDrive Pakistan**, built for learning.
Passengers **offer their own price**, nearby drivers **accept or send a counter-offer**, the passenger **chooses a driver**, and both see each other **live on the map**.

👉 First read **[docs/HOW_INDRIVE_WORKS.md](docs/HOW_INDRIVE_WORKS.md)**. It explains how InDrive works, how drivers are found and where each feature is in the code.

## What is inside

```
indrive_clone/
├── mobile/            Flutter app (passenger + driver in one app)
├── backend/           Node.js server (API + realtime)
├── docs/              How it works, Firebase setup, API list
└── docker-compose.yml Runs database + Redis + server with one command
```

### Tech stack

| Part | Tool | Why |
|---|---|---|
| Mobile app | **Flutter 3.47** (Dart 3.13) | One code for Android + iOS |
| App state | **Riverpod 3** | Modern, testable state management |
| Navigation | **go_router 18** | Login-aware routing, open screen from a push |
| HTTP | **Dio 5** | Auto token refresh |
| Models | **freezed + json_serializable** | Safe, immutable data classes |
| Maps | **flutter_map 8** + OpenStreetMap tiles | Free, no API key needed (change with `--dart-define=TILE_URL=...`) |
| GPS | **geolocator** | Live location, Android foreground service for drivers |
| Realtime | **Socket.IO** | New requests, offers, live car position, chat |
| Push | **Firebase Cloud Messaging** + flutter_local_notifications | Notifications when the app is closed |
| Server | **Node.js 22 + TypeScript + Express 5** | Fast to build, same language on the whole server |
| Database | **PostgreSQL 16 + PostGIS** with **Drizzle ORM** | Rides, users, "points within X meters" |
| Live locations, cache | **Redis** (GEO commands) | Find drivers within 3 km in microseconds |
| Timers | **BullMQ** | Grow search circle, expire offers, survive restarts |
| Validation | **Zod 4** | Check every request |
| Auth | Phone OTP + **JWT** access token + rotating refresh token | Like real apps |
| Routes / addresses | Google Routes + Places (if key) **or** free OSRM + Nominatim | Works without paying |
| Tests | **Vitest** (backend), flutter_test (app) | |

## Run it (step by step)

### 1. Start the backend

**Option A – Docker (easiest).** Install Docker Desktop, then:
```bash
cd indrive_clone
docker compose up --build
```

**Option B – without Docker.** Install Node.js 22, PostgreSQL 16 with PostGIS, and Redis. Then:
```bash
cd indrive_clone/backend
cp .env.example .env        # check DATABASE_URL and REDIS_URL
createdb indrive            # create the database
npm install
npm run dev                 # creates tables and starts on http://localhost:4000
```

Check: open <http://localhost:4000/health> → `{"ok":true}`.
Admin page: <http://localhost:4000/admin> (key: `admin123`).

### 2. Start fake drivers (so you can test alone)
```bash
cd indrive_clone/backend
npm run simulate                         # 8 drivers in Lahore
npm run simulate -- --city karachi --count 12
npm run simulate -- --lat 33.6844 --lng 73.0479   # anywhere
```
They go online, send offers to your requests and **drive on real roads** to you.
(With Docker: run `npm install` and `npm run simulate` from `backend` on your computer.)

### 3. Run the Flutter app
```bash
cd indrive_clone/mobile
flutter pub get
flutter run                                                  # Android emulator uses http://10.0.2.2:4000
flutter run --dart-define=API_URL=http://192.168.1.10:4000   # real phone: use your computer's Wi-Fi IP
```

### 4. Try the full flow
1. Choose language → enter any Pakistani number (e.g. `3001234567`).
2. The OTP code is shown in the app (dev mode) and in the server log.
3. Allow location. On an emulator set the location to Lahore (Extended controls → Location), or start the simulator near you with `--lat --lng`.
4. Tap **Where to?**, pick a place, choose a vehicle, set your price, tap **Find a driver**.
5. Offers arrive in a few seconds → **Accept** one → watch the car come to you.
6. To test the **driver side**: open the menu → **Become a driver** → fill the form (auto approved in dev) → **Go online**. Use a second phone/emulator as passenger.

### 5. Push notifications (optional)
See **[docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md)**. Without it the app works fully while open.

## Tests
```bash
cd backend && npm test        # full ride flow: login → request → offers → accept → tracking → chat → complete → rating
cd mobile && flutter test     # models read real server JSON, map helpers, "walking towards pickup" logic
cd mobile && flutter analyze  # no issues
```

## Release and quality
- **[docs/QA_REPORT.md](docs/QA_REPORT.md)** – what we tested as passenger + driver, bugs found and fixed
- **[docs/RELEASE.md](docs/RELEASE.md)** – put the backend online, sign and publish the Android / iOS app
- CI: `.github/workflows/indrive-clone-ci.yml` runs backend tests and Flutter checks on every push

## More docs
- [docs/HOW_INDRIVE_WORKS.md](docs/HOW_INDRIVE_WORKS.md) – analysis of InDrive + feature list
- [docs/API.md](docs/API.md) – all REST endpoints and Socket.IO events
- [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) – push notifications

## Notes
- This is a **student project for learning**. It is not connected to InDrive. "inDrive" is a trademark of its owner. Do not publish it to app stores under that name or logo.
- Public OpenStreetMap services (tiles, OSRM, Nominatim) are free but have fair-use limits. For many users, use a paid tile provider (Mapbox, MapTiler) with `--dart-define=TILE_URL=...`. For heavy use, add a Google Maps key (`GOOGLE_MAPS_API_KEY`) or host your own.
- Before real use: change `JWT_*` secrets and `ADMIN_KEY`, set `DEV_OTP=false` with an SMS provider, use HTTPS.

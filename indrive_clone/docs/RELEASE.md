# Publish the app (Play Store / App Store)

This project is a student project. If you publish it, **change the name, logo and package id** – "inDrive" is a trademark of its owner.

## 1. Backend in production
1. Rent a small server (2 GB RAM is enough to start) or use a platform like Railway / Render / Fly.io.
2. Use managed PostgreSQL **with PostGIS** and managed Redis.
3. Set these in the server environment (see `backend/.env.example`):
   - `NODE_ENV=production`, `PUBLIC_URL=https://api.your-domain.com`
   - long random `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET` (`openssl rand -hex 32`)
   - `ADMIN_KEY` = a strong password
   - `DEV_OTP=false` + Twilio (or any SMS provider) keys
   - `AUTO_APPROVE_DRIVERS=false` (approve drivers in `/admin`)
   - `FIREBASE_SERVICE_ACCOUNT` for push notifications
   - `GOOGLE_MAPS_API_KEY` (recommended for many users; the free OpenStreetMap servers have fair-use limits)
4. Put HTTPS in front (Caddy / Nginx / the platform's HTTPS). Socket.IO needs WebSocket support.
5. Check: `https://api.your-domain.com/health` → `{"ok":true}`.

## 2. App settings
- Server URL: build with `--dart-define=API_URL=https://api.your-domain.com`
- Map tiles: for many users use a paid tile provider: `--dart-define=TILE_URL=https://.../{z}/{x}/{y}.png`
- App id: change `applicationId` in `android/app/build.gradle.kts` and the iOS Bundle Identifier in Xcode.
- Version: `version: 1.0.0+1` in `pubspec.yaml` (increase the `+number` for every upload).
- Force update: set `MIN_APP_VERSION` on the server – older apps show "Please update".
- Maintenance: `MAINTENANCE=true` on the server shows a "We will be back soon" screen.
- In `android/app/src/main/AndroidManifest.xml` remove `usesCleartextTraffic="true"` when you only use HTTPS
  (and in `ios/Runner/Info.plist` remove `NSAllowsArbitraryLoads`).

## 3. Android (Google Play)
```bash
# one time: create your upload key (keep it safe, never commit it)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Create `mobile/android/key.properties` (it is in `.gitignore`):
```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/home/you/upload-keystore.jks
```
Build:
```bash
cd mobile
flutter build appbundle --release --dart-define=API_URL=https://api.your-domain.com
# file: build/app/outputs/bundle/release/app-release.aab -> upload in Play Console
```
Play Console needs: privacy policy URL (`https://api.your-domain.com/legal/privacy`), screenshots,
the **location in background** declaration (drivers share location while online; show a short video),
and the data safety form (location, phone number, photos, messages).

## 4. iOS (App Store) – needs a Mac
1. `open ios/Runner.xcworkspace`, set your Team and Bundle Identifier.
2. Capabilities: Push Notifications, Background Modes (Location updates, Remote notifications).
3. `flutter build ipa --release --dart-define=API_URL=https://api.your-domain.com`
4. Upload with Xcode / Transporter. App Review needs a demo account: give them a test phone number and turn on `DEV_OTP` for that number only, or use a real SMS provider.

## 5. App icon and splash screen
Images are in `mobile/assets/branding/`. After changing them run:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

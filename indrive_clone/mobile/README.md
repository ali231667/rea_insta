# inDrive clone – Flutter app

One app for **passengers** and **drivers** (switch in the side menu), like InDrive.

See the main [README](../README.md) for how to run everything.

```bash
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:4000   # Android emulator (default)
flutter test
flutter analyze
# after changing a model in lib/models:
dart run build_runner build
```

## Folder structure

```
lib/
├── main.dart, app.dart          start, theme, language, router
├── core/
│   ├── config/                  API URL, map tiles, emergency numbers
│   ├── network/                 Dio client (auto token refresh), errors
│   ├── realtime/                Socket.IO connection + event names
│   ├── location/                GPS (permission, live stream, driver foreground service)
│   ├── push/                    Firebase Cloud Messaging
│   ├── router/                  go_router (login-aware redirects)
│   ├── storage/                 secure token storage, settings
│   ├── l10n/                    English / Urdu texts
│   └── utils/                   PKR / km format, polyline, "walking towards" tracker
├── models/                      freezed data classes (User, Ride, Offer, ...)
├── data/                        repositories = API calls
├── widgets/                     map, markers, buttons, avatar, rating
└── features/
    ├── auth/                    onboarding, phone, OTP, name, session state
    ├── passenger/               home map, search, order sheets, ride screen (offers + tracking)
    ├── driver/                  sign-up, online + order feed, offer sheet, trip, earnings
    └── common/                  menu, chat, history, rating, profile, settings, safety, help
```

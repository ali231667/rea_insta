# QA report – testing as a real passenger and driver

**How we tested:** two phones at the same time (one passenger, one driver) against the real backend, plus fake drivers from the simulator. Screens were run at phone size (400×860) and screenshots were checked one by one. GPS was moved step by step to simulate driving. The Android APK (debug and release) was built to make sure the phone build works.

**Flows tested:** first start → language → phone login → OTP → name → home map → search address → choose vehicle → offer price → drivers see request → driver counter-offer → passenger accepts → live tracking → chat → driver arrived → trip started → driver drives → trip finished → both rate → history. Also: driver sign-up with photos, cancel by passenger, cancel by driver + "Order again", support ticket, safety contacts, legal pages, share trip page.

## Bugs found and fixed

| # | Where | Bug | Fix |
|---|---|---|---|
| 1 | Map | Route line crashed ("infinite loop") on some platforms | Route decoder no longer uses the `~` operator (unsigned on web) |
| 2 | Map | On small screens the map zoomed out to the whole world | Padding is reduced when it is bigger than the map |
| 3 | Home | Pickup pin was not at the real map center → wrong pickup address | Pin tip is placed exactly at the center |
| 4 | Ride | Car hidden behind the bottom panel; map did not follow the car | Map fits above the measured panel and follows the car (stops when you move the map) |
| 5 | Ride | Line from car to pickup was straight | Real road route, refreshed when the car moves 150 m |
| 6 | Searching | "0 drivers saw your request" while offers arrived | Count is also sent with the ride data |
| 7 | Driver sign-up | Photos were not uploaded (file paths) | Photos sent as bytes – works on all platforms |
| 8 | Driver sign-up | Wrong year (e.g. "021") gave a technical server error | Year and number plate are checked in the form |
| 9 | Realtime | Events lost while offline / in background were never shown | App reloads ride and requests after reconnect and when it comes back |
| 10 | Reopen app | Map empty until the driver's next GPS update | Last known car position is sent with the ride |
| 11 | Matching | Passenger could accept a driver who went offline | Server refuses: "This driver is not available any more" |
| 12 | UI | "Passenger is at the pickup" still shown after the trip | Shown only while waiting for pickup |
| 13 | Search | Address search empty when many people type (OpenStreetMap limit 1/s → HTTP 429) | Requests are paced and fall back to a second service (Photon) |

## Features added after QA (what store apps have)
- Help center: report a problem / lost item (linked to a ride), replies from the admin page with push notification
- Live "share trip" web page for family + SMS to trusted contacts (also on SOS)
- Terms of Service and Privacy Policy (in the app and as public links for the stores), About + licenses
- Force update and maintenance mode controlled by the server
- "No connection – reconnecting" banner
- Invite friends, admin: users list + block/unblock, support tickets
- App icon, splash screen, release signing + code shrinking, CI (GitHub Actions)

## Automatic tests
- Backend: 24 end-to-end tests (`npm test`)
- App: unit, model (real server JSON), map and app-flow tests (`flutter test`), `flutter analyze` clean

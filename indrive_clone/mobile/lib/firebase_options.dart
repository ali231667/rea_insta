// PLACEHOLDER FILE.
//
// To turn on push notifications, create a Firebase project and run (in this folder):
//   dart pub global activate flutterfire_cli
//   flutterfire configure
// That command REPLACES this file with your real keys. See docs/FIREBASE_SETUP.md.
//
// Until then the app works normally, only push notifications are off.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform =>
      throw UnsupportedError('Firebase is not configured yet. Run "flutterfire configure" (see docs/FIREBASE_SETUP.md).');
}

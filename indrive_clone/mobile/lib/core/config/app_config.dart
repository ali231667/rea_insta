import 'dart:io' show Platform;

/// Where the backend runs.
///
/// Change it when you run the app:
///   flutter run --dart-define=API_URL=http://192.168.1.10:4000
///
/// Default: Android emulator uses 10.0.2.2 to reach your computer, iOS simulator uses localhost.
class AppConfig {
  static const _fromEnv = String.fromEnvironment('API_URL');

  static String get apiUrl {
    if (_fromEnv.isNotEmpty) return _fromEnv;
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:4000';
    } catch (_) {}
    return 'http://localhost:4000';
  }

  static String get apiBase => '$apiUrl/api/v1';

  /// Map tiles from OpenStreetMap (free, no key). Fair use only: for a real app use a paid
  /// provider (Mapbox, MapTiler, Google) and put its URL here.
  static const tileUrl = String.fromEnvironment('TILE_URL', defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
  static const userAgent = 'com.studentproject.indrive_clone';

  static const currency = 'PKR';

  /// Emergency numbers in Pakistan.
  static const police = '15';
  static const rescue = '1122';
  static const ambulance = '115';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationException implements Exception {
  LocationException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// GPS helper (permission + current position + live updates).
class LocationService {
  /// Default map center when GPS is not ready: Lahore.
  static const fallback = LatLng(31.5204, 74.3587);

  Future<void> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationException('Please turn on location (GPS)');
    }
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied) throw LocationException('Location permission is needed to find rides');
    if (p == LocationPermission.deniedForever) {
      throw LocationException('Location permission is blocked. Please allow it in Settings.');
    }
  }

  Future<Position> current() async {
    await ensurePermission();
    final last = await Geolocator.getLastKnownPosition();
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
      );
    } catch (_) {
      if (last != null) return last;
      rethrow;
    }
  }

  /// Live GPS. For drivers on Android we use a foreground service so updates continue when the screen is off.
  Stream<Position> stream({bool driverMode = false}) {
    final LocationSettings settings;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        intervalDuration: const Duration(seconds: 3),
        foregroundNotificationConfig: driverMode
            ? const ForegroundNotificationConfig(
                notificationTitle: 'You are online',
                notificationText: 'Sharing your location to receive ride requests',
                enableWakeLock: true,
              )
            : null,
      );
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: driverMode,
        allowBackgroundLocationUpdates: driverMode,
      );
    } else {
      settings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5);
    }
    return Geolocator.getPositionStream(locationSettings: settings);
  }
}

extension PositionX on Position {
  LatLng get latLng => LatLng(latitude, longitude);
}

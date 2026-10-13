import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

/// Runs when a push arrives and the app is closed / in background.
/// The system shows the notification itself, we have nothing else to do.
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

/// Push notifications with Firebase Cloud Messaging.
///
/// - Background / closed app: Android & iOS show the notification by themselves.
/// - App open: we show it with flutter_local_notifications (FCM does not show it by default).
/// - Tap on a notification: opens the screen in data["route"] (e.g. /ride).
///
/// If Firebase is not configured (no `flutterfire configure` yet) everything here is skipped.
class PushService {
  PushService._();
  static final instance = PushService._();

  bool enabled = false;
  final _local = FlutterLocalNotificationsPlugin();

  /// Set by the app: how to open a screen (go_router).
  void Function(String route)? onOpenRoute;
  String? _pendingRoute;

  static const _channel = AndroidNotificationChannel(
    'rides',
    'Rides',
    description: 'Ride requests, offers and trip updates',
    importance: Importance.high,
  );

  Future<void> init() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      debugPrint('Push notifications are off: $e');
      return;
    }
    enabled = true;
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false),
      ),
      onDidReceiveNotificationResponse: (r) => _open(r.payload),
    );
    await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    // iOS: show notifications also when the app is open.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n == null || defaultTargetPlatform == TargetPlatform.iOS) return; // iOS shows it itself (see above)
      _local.show(
        id: m.hashCode,
        title: n.title,
        body: n.body,
        payload: m.data['route'] as String?,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(_channel.id, _channel.name,
              channelDescription: _channel.description, importance: Importance.high, priority: Priority.high),
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data['route'] as String?));
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _pendingRoute = initial.data['route'] as String?;
  }

  void _open(String? route) {
    if (route == null || route.isEmpty) return;
    if (onOpenRoute != null) {
      onOpenRoute!(route);
    } else {
      _pendingRoute = route;
    }
  }

  /// Call when the router is ready (opens the screen of the notification that started the app).
  void flushPending() {
    final r = _pendingRoute;
    _pendingRoute = null;
    if (r != null) _open(r);
  }

  /// Asks permission and returns this phone's FCM token (send it to the backend).
  Future<String?> getToken() async {
    if (!enabled) return null;
    try {
      final perm = await FirebaseMessaging.instance.requestPermission();
      if (perm.authorizationStatus == AuthorizationStatus.denied) return null;
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('FCM token error: $e');
      return null;
    }
  }

  Stream<String> get onTokenRefresh => enabled ? FirebaseMessaging.instance.onTokenRefresh : const Stream.empty();

  Future<void> deleteToken() async {
    if (enabled) await FirebaseMessaging.instance.deleteToken().catchError((_) {});
  }
}

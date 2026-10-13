import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/push/push_service.dart';
import '../../models/user.dart';

enum AuthStatus { loading, onboarding, loggedOut, needsProfile, loggedIn }

/// App mode: InDrive uses one app for both passengers and drivers.
enum AppMode { passenger, driver }

@immutable
class SessionState {
  const SessionState({
    this.status = AuthStatus.loading,
    this.me,
    this.mode = AppMode.passenger,
    this.language = 'en',
    this.themeMode = ThemeMode.system,
  });

  final AuthStatus status;
  final Me? me;
  final AppMode mode;
  final String language;
  final ThemeMode themeMode;

  AppUser? get user => me?.user;
  DriverProfile? get driver => me?.driver;
  bool get isApprovedDriver => driver?.status == 'approved';

  SessionState copyWith({AuthStatus? status, Me? me, bool clearMe = false, AppMode? mode, String? language, ThemeMode? themeMode}) =>
      SessionState(
        status: status ?? this.status,
        me: clearMe ? null : (me ?? this.me),
        mode: mode ?? this.mode,
        language: language ?? this.language,
        themeMode: themeMode ?? this.themeMode,
      );
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(SessionController.new);

/// Login state of the whole app.
class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    final prefs = ref.read(prefsProvider);
    final lang = prefs.language;
    L10n.language = lang;
    Future.microtask(_init);
    return SessionState(
      language: lang,
      mode: prefs.mode == 'driver' ? AppMode.driver : AppMode.passenger,
      themeMode: ThemeMode.values.byName(prefs.themeMode),
    );
  }

  Future<void> _init() async {
    final prefs = ref.read(prefsProvider);
    if (!prefs.seenOnboarding) {
      state = state.copyWith(status: AuthStatus.onboarding);
      return;
    }
    if (!ref.read(tokenStorageProvider).hasSession) {
      state = state.copyWith(status: AuthStatus.loggedOut);
      return;
    }
    try {
      await refreshMe();
    } catch (_) {
      // No internet at start: keep the user logged in, screens will retry.
      if (ref.read(tokenStorageProvider).hasSession) {
        state = state.copyWith(status: AuthStatus.loggedIn);
        ref.read(socketProvider).connect();
      } else {
        state = state.copyWith(status: AuthStatus.loggedOut);
      }
    }
  }

  Future<void> refreshMe() async {
    final me = await ref.read(userRepositoryProvider).me();
    final needsProfile = (me.user.name ?? '').trim().isEmpty;
    var mode = state.mode;
    if (mode == AppMode.driver && me.driver?.status != 'approved') mode = AppMode.passenger;
    state = state.copyWith(me: me, mode: mode, status: needsProfile ? AuthStatus.needsProfile : AuthStatus.loggedIn);
    if (!needsProfile) {
      ref.read(socketProvider).connect();
      unawaited(_registerPush());
    }
  }

  StreamSubscription<String>? _tokenSub;

  /// Sends this phone's FCM token to the backend so it can send push notifications.
  Future<void> _registerPush() async {
    final push = PushService.instance;
    final token = await push.getToken();
    if (token == null) return;
    try {
      await ref.read(userRepositoryProvider).update(fcmToken: token);
    } catch (_) {}
    _tokenSub ??= push.onTokenRefresh.listen((t) async {
      try {
        await ref.read(userRepositoryProvider).update(fcmToken: t);
      } catch (_) {}
    });
  }

  Future<void> finishOnboarding(String language) async {
    await setLanguage(language);
    await ref.read(prefsProvider).setSeenOnboarding();
    state = state.copyWith(status: AuthStatus.loggedOut);
  }

  /// After the OTP is correct.
  Future<void> loggedIn() => refreshMe();

  Future<void> completeProfile({required String name, String? email}) async {
    final me = await ref.read(userRepositoryProvider).update(name: name, email: email, language: state.language);
    state = state.copyWith(me: me, status: AuthStatus.loggedIn);
    ref.read(socketProvider).connect();
    unawaited(_registerPush());
  }

  void updateMe(Me me) => state = state.copyWith(me: me);

  void updateDriver(DriverProfile d) {
    final me = state.me;
    if (me != null) state = state.copyWith(me: me.copyWith(driver: d));
  }

  void setBalance(int balance) {
    final d = state.driver;
    if (d != null) updateDriver(d.copyWith(balance: balance));
  }

  Future<void> setMode(AppMode mode) async {
    await ref.read(prefsProvider).setMode(mode.name);
    state = state.copyWith(mode: mode);
  }

  Future<void> setLanguage(String lang) async {
    L10n.language = lang;
    await ref.read(prefsProvider).setLanguage(lang);
    state = state.copyWith(language: lang);
    if (state.status == AuthStatus.loggedIn) {
      try {
        await ref.read(userRepositoryProvider).update(language: lang);
      } catch (_) {}
    }
  }

  Future<void> setThemeMode(ThemeMode m) async {
    await ref.read(prefsProvider).setThemeMode(m.name);
    state = state.copyWith(themeMode: m);
  }

  Future<void> logout() async {
    ref.read(socketProvider).disconnect();
    // Stop pushes to this phone for the old account.
    try {
      await ref.read(userRepositoryProvider).update(fcmToken: '');
    } catch (_) {}
    await PushService.instance.deleteToken();
    await _tokenSub?.cancel();
    _tokenSub = null;
    await ref.read(authRepositoryProvider).logout();
    await ref.read(prefsProvider).setMode('passenger');
    state = state.copyWith(status: AuthStatus.loggedOut, clearMe: true, mode: AppMode.passenger);
  }

  Future<void> deleteAccount() async {
    await ref.read(userRepositoryProvider).deleteAccount();
    await logout();
  }

  /// Refresh token is not valid any more.
  void onSessionExpired() {
    ref.read(socketProvider).disconnect();
    state = state.copyWith(status: AuthStatus.loggedOut, clearMe: true, mode: AppMode.passenger);
  }
}

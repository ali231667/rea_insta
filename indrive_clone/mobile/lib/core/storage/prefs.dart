import 'package:shared_preferences/shared_preferences.dart';

/// Small app settings (not secret): language, mode, theme, onboarding.
class Prefs {
  Prefs(this._p);
  final SharedPreferences _p;

  static Future<Prefs> create() async => Prefs(await SharedPreferences.getInstance());

  String get language => _p.getString('language') ?? 'en';
  Future<void> setLanguage(String v) => _p.setString('language', v);

  /// 'passenger' or 'driver'
  String get mode => _p.getString('mode') ?? 'passenger';
  Future<void> setMode(String v) => _p.setString('mode', v);

  bool get seenOnboarding => _p.getBool('seen_onboarding') ?? false;
  Future<void> setSeenOnboarding() => _p.setBool('seen_onboarding', true);

  /// 'system', 'light' or 'dark'
  String get themeMode => _p.getString('theme_mode') ?? 'system';
  Future<void> setThemeMode(String v) => _p.setString('theme_mode', v);

  List<String> get emergencyContacts => _p.getStringList('emergency_contacts') ?? [];
  Future<void> setEmergencyContacts(List<String> v) => _p.setStringList('emergency_contacts', v);
}

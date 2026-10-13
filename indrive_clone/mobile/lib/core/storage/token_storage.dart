import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Login tokens are saved in the phone's secure storage (Keychain / Keystore), not in plain files.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage]) : _s = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _s;

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';

  String? _cachedAccess;
  String? _cachedRefresh;

  Future<void> load() async {
    _cachedAccess = await _s.read(key: _access);
    _cachedRefresh = await _s.read(key: _refresh);
  }

  String? get accessToken => _cachedAccess;
  String? get refreshToken => _cachedRefresh;
  bool get hasSession => _cachedRefresh != null;

  Future<void> save(String access, String refresh) async {
    _cachedAccess = access;
    _cachedRefresh = refresh;
    await _s.write(key: _access, value: access);
    await _s.write(key: _refresh, value: refresh);
  }

  Future<void> clear() async {
    _cachedAccess = null;
    _cachedRefresh = null;
    await _s.delete(key: _access);
    await _s.delete(key: _refresh);
  }
}

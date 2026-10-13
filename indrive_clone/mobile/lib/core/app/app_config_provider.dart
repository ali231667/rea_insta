import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_config.dart';

/// Settings from the server (GET /config): app version rules, maintenance, legal links.
class RemoteConfig {
  RemoteConfig({
    required this.appVersion,
    required this.minAppVersion,
    required this.latestAppVersion,
    required this.storeUrl,
    this.maintenanceMessage,
    required this.termsUrl,
    required this.privacyUrl,
    required this.supportPhone,
  });

  final String appVersion;
  final String minAppVersion;
  final String latestAppVersion;
  final String storeUrl;
  final String? maintenanceMessage;
  final String termsUrl;
  final String privacyUrl;
  final String supportPhone;

  bool get mustUpdate => compareVersions(appVersion, minAppVersion) < 0;
  bool get canUpdate => compareVersions(appVersion, latestAppVersion) < 0;
}

/// "1.2.10" vs "1.10.0" -> negative when a < b.
int compareVersions(String a, String b) {
  List<int> parts(String v) => v.split('+').first.split('.').map((x) => int.tryParse(x) ?? 0).toList();
  final pa = parts(a), pb = parts(b);
  for (var i = 0; i < 3; i++) {
    final x = i < pa.length ? pa[i] : 0, y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}

final remoteConfigProvider = FutureProvider<RemoteConfig?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final r = await Dio(BaseOptions(baseUrl: AppConfig.apiBase, connectTimeout: const Duration(seconds: 8))).get<Map<String, dynamic>>('/config');
    final d = r.data!;
    final legal = (d['legal'] as Map?) ?? const {};
    return RemoteConfig(
      appVersion: info.version,
      minAppVersion: (d['minAppVersion'] as String?) ?? '0.0.0',
      latestAppVersion: (d['latestAppVersion'] as String?) ?? info.version,
      storeUrl: (d['storeUrl'] as String?) ?? '',
      maintenanceMessage: (d['maintenance'] as Map?)?['message'] as String?,
      termsUrl: (legal['termsUrl'] as String?) ?? '${AppConfig.apiUrl}/legal/terms',
      privacyUrl: (legal['privacyUrl'] as String?) ?? '${AppConfig.apiUrl}/legal/privacy',
      supportPhone: (d['supportPhone'] as String?) ?? '',
    );
  } catch (_) {
    return null; // offline: do not block the app
  }
});

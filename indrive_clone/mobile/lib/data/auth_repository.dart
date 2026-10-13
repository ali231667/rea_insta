import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/token_storage.dart';

class OtpRequestResult {
  OtpRequestResult({required this.phone, required this.resendInSec, this.devCode});
  final String phone;
  final int resendInSec;

  /// Only in development: the server sends the code back so you can test without SMS.
  final String? devCode;
}

class AuthRepository {
  AuthRepository(this.api, this.tokens);
  final ApiClient api;
  final TokenStorage tokens;

  Future<OtpRequestResult> requestOtp(String phone) async {
    final r = await api.post<Map<String, dynamic>>('/auth/otp/request', {'phone': phone});
    return OtpRequestResult(
      phone: r['phone'] as String,
      resendInSec: (r['resendInSec'] as num?)?.toInt() ?? 60,
      devCode: r['devCode'] as String?,
    );
  }

  /// Returns true when this is a new user (must enter name).
  Future<bool> verifyOtp(String phone, String code) async {
    final r = await api.post<Map<String, dynamic>>('/auth/otp/verify', {'phone': phone, 'code': code});
    await tokens.save(r['accessToken'] as String, r['refreshToken'] as String);
    return r['isNewUser'] == true;
  }

  Future<void> logout() async {
    final rt = tokens.refreshToken;
    if (rt != null) {
      try {
        await api.dio.post('/auth/logout', data: {'refreshToken': rt}, options: Options(extra: {'noAuth': true}));
      } catch (_) {}
    }
    await tokens.clear();
  }
}

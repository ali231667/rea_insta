import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// HTTP client for our backend.
/// - adds the "Authorization: Bearer TOKEN" header to every request
/// - when the short access token expires, gets a new one with the refresh token and repeats the request
class ApiClient {
  ApiClient(this.tokens, {required this.onSessionExpired}) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    ));
    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        final t = tokens.accessToken;
        if (t != null && options.extra['noAuth'] != true) options.headers['Authorization'] = 'Bearer $t';
        handler.next(options);
      },
      onError: (err, handler) async {
        final code = (err.response?.data is Map) ? (err.response!.data['error']?['code']) : null;
        final isExpired = err.response?.statusCode == 401 && code == 'token_expired';
        if (!isExpired || err.requestOptions.extra['retried'] == true) return handler.next(err);
        try {
          await refresh();
          final opts = err.requestOptions..extra['retried'] = true;
          opts.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
          handler.resolve(await dio.fetch(opts));
        } catch (_) {
          handler.next(err);
        }
      },
    ));
  }

  final TokenStorage tokens;
  final void Function() onSessionExpired;
  late final Dio dio;
  Future<void>? _refreshing;

  /// Gets a new access token. Many requests can fail at once, so only one refresh runs.
  Future<void> refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<void> _doRefresh() async {
    final rt = tokens.refreshToken;
    if (rt == null) throw ApiException('Not logged in', code: 'unauthorized');
    try {
      final res = await Dio(BaseOptions(baseUrl: AppConfig.apiBase)).post('/auth/refresh', data: {'refreshToken': rt});
      await tokens.save(res.data['accessToken'] as String, res.data['refreshToken'] as String);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await tokens.clear();
        onSessionExpired();
      }
      rethrow;
    }
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) => _wrap(() => dio.get(path, queryParameters: query));
  Future<T> post<T>(String path, [Object? data]) => _wrap(() => dio.post(path, data: data));
  Future<T> patch<T>(String path, [Object? data]) => _wrap(() => dio.patch(path, data: data));
  Future<T> delete<T>(String path) => _wrap(() => dio.delete(path));

  Future<T> _wrap<T>(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return res.data as T;
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

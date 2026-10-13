import 'package:dio/dio.dart';

/// Error from the server (or no internet) with a message we can show to the user.
class ApiException implements Exception {
  ApiException(this.message, {this.code, this.status});
  final String message;
  final String? code;
  final int? status;

  factory ApiException.from(Object e) {
    if (e is ApiException) return e;
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['error'] is Map) {
        final err = data['error'] as Map;
        return ApiException(err['message']?.toString() ?? 'Something went wrong',
            code: err['code']?.toString(), status: e.response?.statusCode);
      }
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
          return ApiException('Cannot reach the server. Check your internet.', code: 'network');
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiException('The server is slow. Please try again.', code: 'timeout');
        default:
          return ApiException('Something went wrong (${e.response?.statusCode ?? e.type.name})', status: e.response?.statusCode);
      }
    }
    return ApiException(e.toString());
  }

  @override
  String toString() => message;
}

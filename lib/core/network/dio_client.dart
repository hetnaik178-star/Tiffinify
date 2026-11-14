import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';

class DioClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
    headers: {'Content-Type': 'application/json'},
  ))
    ..interceptors.add(AuthInterceptor())
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}

/// JWT token auto-attach (PDF §8 security)
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final msg = err.response?.data?['message'] ?? err.message ?? 'Network error';
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: ApiException(msg.toString(), statusCode: err.response?.statusCode ?? 500),
    ));
  }
}
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/injection_container.dart';

import '../../../features/auth/domain/repositories/auth_repository.dart';

class LoggingInterceptor extends Interceptor {
  static bool _isRefreshing = false;
  static Future<void>? _refreshFuture;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🌐 [API Request] --> ${options.method} ${options.uri}");
    print("📁 Headers: ${options.headers}");
    print("📦 Body: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ [API Response] <-- STATUS: ${response.statusCode}");
    print("💬 Data: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print("❌ [API Error] <-- STATUS: ${err.response?.statusCode}");
    print("⚠️ Message: ${err.message}");
    if (err.response?.data != null) {
      print("📦 Error Body: ${err.response?.data}");
    }

    if (err.response?.statusCode == 401) {
      final prefs = sl<SharedPreferences>();
      final String? refreshToken = prefs.getString("refresh_token");

      if (refreshToken != null && refreshToken.isNotEmpty) {
        if (_isRefreshing) {
          try {
            await _refreshFuture;
            final String? newToken = prefs.getString("token");
            if (newToken != null) {
              final requestOptions = err.requestOptions;
              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final cloneDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
              final response = await cloneDio.fetch(requestOptions);
              return handler.resolve(response);
            }
          } catch (e) {
            return super.onError(err, handler);
          }
        }

        _isRefreshing = true;
        _refreshFuture = _doRefresh(err, handler, refreshToken, prefs);
        return;
      }
    }

    super.onError(err, handler);
  }

  Future<void> _doRefresh(DioException err, ErrorInterceptorHandler handler, String refreshToken, SharedPreferences prefs) async {
    try {
      print("🔄 جاري محاولة تجديد التوكن تلقائياً...");

      final authRepository = sl<AuthRepository>();
      final result = await authRepository.refreshToken(refreshToken: refreshToken);

      await result.fold(
            (failure) async {
          print("📉 فشل تجديد التوكن (الـ Refresh Token منتهي أيضاً)!");
          _isRefreshing = false;
          handler.next(err);
        },
            (authEntity) async {
          print("🚀 تم تجديد التوكن بنجاح! جاري إعادة إرسال الطلب الأصلي...");
          
          // Save the new token and refresh token
          await prefs.setString("token", authEntity.token);
          if (authEntity.refreshToken != null) {
            await prefs.setString("refresh_token", authEntity.refreshToken!);
          }

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer ${authEntity.token}';

          _isRefreshing = false;

          final cloneDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
          final response = await cloneDio.fetch(requestOptions);

          handler.resolve(response);
        },
      );
    } catch (e) {
      print("💥 حدث خطأ غير متوقع أثناء محاولة التجديد التلقائي: $e");
      _isRefreshing = false;
      return handler.next(err);
    }
  }
}

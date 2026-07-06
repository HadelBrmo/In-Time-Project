import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/injection_container.dart';

import '../../../features/auth/domain/repositories/auth_repository.dart';

class LoggingInterceptor extends Interceptor {
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
        try {
          print("🔄 جاري محاولة تجديد التوكن تلقائياً...");

          final authRepository = sl<AuthRepository>();
          final result = await authRepository.refreshToken(refreshToken: refreshToken);

          return await result.fold(
                (failure) {
              print("📉 فشل تجديد التوكن (الـ Refresh Token منتهي أيضاً)!");
              return super.onError(err, handler);
            },
                (authEntity) async {
              print("🚀 تم تجديد التوكن بنجاح! جاري إعادة إرسال الطلب الأصلي...");

              final requestOptions = err.requestOptions;
              requestOptions.headers['Authorization'] = 'Bearer ${authEntity.token}';

              final cloneDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
              final response = await cloneDio.fetch(requestOptions);

              return handler.resolve(response);
            },
          );
        } catch (e) {
          print("💥 حدث خطأ غير متوقع أثناء محاولة التجديد التلقائي: $e");
        }
      }
    }

    super.onError(err, handler);
  }
}
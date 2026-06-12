import 'package:dio/dio.dart';

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ [API Error] <-- STATUS: ${err.response?.statusCode}");
    print("⚠️ Message: ${err.message}");
    super.onError(err, handler);
  }
}


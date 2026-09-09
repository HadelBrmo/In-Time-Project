import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CachingInterceptor extends Interceptor {
  static const String _cacheBoxName = 'api_cache_box';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method == "GET") {
      final cacheKey = options.uri.toString();

      final box = await Hive.openBox(_cacheBoxName);

      if (box.containsKey(cacheKey)) {
        final cachedData = box.get(cacheKey);

        print("💾 [Cache Hit] جلب البيانات محلياً للرابط: $cacheKey");

        final response = Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
        );
        return handler.resolve(response);
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method == "GET" && response.statusCode == 200) {
      final cacheKey = response.requestOptions.uri.toString();

      final box = await Hive.openBox(_cacheBoxName);

      await box.put(cacheKey, response.data);

      print("📥 [Cache Saved] تم حفظ كاش جديد للرابط: $cacheKey");
    }
    super.onResponse(response, handler);
  }
}
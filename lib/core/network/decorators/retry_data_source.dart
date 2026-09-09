import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final int retryDelayMilliseconds;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelayMilliseconds = 2000,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var requestOptions = err.requestOptions;

    if (_shouldRetry(err) && requestOptions.extra['retryCount'] == null) {
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          retryCount++;
          print("🔄 [Retry] المحاولة رقم ($retryCount) للطلب: ${requestOptions.path}");

          await Future.delayed(Duration(milliseconds: retryDelayMilliseconds));

          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (e) {
          if (retryCount >= maxRetries) {
            break;
          }
        }
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}


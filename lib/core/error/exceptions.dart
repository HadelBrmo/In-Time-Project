import 'package:dio/dio.dart';

class AppExceptions {}

class ServerException {
  final int? statusCode;
  final String message;

  ServerException({this.statusCode, this.message = 'حدث خطأ في الاتصال بالسيرفر'});
}

class CacheException {}

class ServerExceptionWithDetails implements Exception {
  final int? statusCode;
  final String message;

  ServerExceptionWithDetails({this.statusCode, required this.message});

  factory ServerExceptionWithDetails.fromResponse(
    Response<dynamic>? response, {
    String fallback = 'حدث خطأ في الاتصال بالسيرفر',
  }) {
    final dynamic data = response?.data;
    String extractedMessage = fallback;

    if (data is Map) {
      final dynamic message = data['message'] ?? data['error'] ?? data['errors'];

      if (message is String && message.trim().isNotEmpty) {
        extractedMessage = message;
      } else if (message is Map && message.isNotEmpty) {
        final firstValue = message.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          final firstItem = firstValue.first;
          if (firstItem is String && firstItem.trim().isNotEmpty) {
            extractedMessage = firstItem;
          }
        } else if (firstValue is String && firstValue.trim().isNotEmpty) {
          extractedMessage = firstValue;
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      extractedMessage = data;
    }

    return ServerExceptionWithDetails(
      statusCode: response?.statusCode,
      message: extractedMessage,
    );
  }

  factory ServerExceptionWithDetails.fromDioException(
    DioException e, {
    String fallback = 'حدث خطأ في الاتصال بالسيرفر',
  }) {
    return ServerExceptionWithDetails.fromResponse(
      e.response,
      fallback: fallback,
    );
  }
}



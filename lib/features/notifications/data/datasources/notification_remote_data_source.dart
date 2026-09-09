import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getMyNotifications();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
  Future<void> updateFcmToken(String token);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getMyNotifications() async {
    try {
      final response = await dio.get('/my-notifications');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل الإشعارات',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل الإشعارات',
      );
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      final response = await dio.put('/notifications/$id/read');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل تعليم الإشعار كمقروء',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تعليم الإشعار كمقروء',
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final response = await dio.put('/notifications/read-all');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل تعليم جميع الإشعارات كمقروءة',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تعليم جميع الإشعارات كمقروءة',
      );
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get('/notifications/unread-count');
      if (response.statusCode == 200) {
        return response.data['data']['count'];
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل عدد الإشعارات غير المقروءة',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل عدد الإشعارات غير المقروءة',
      );
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    try {
      final response = await dio.post('/update-fcm-token', data: {'fcm_token': token});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل تحديث جهاز الإشعارات',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحديث جهاز الإشعارات',
      );
    }
  }
}

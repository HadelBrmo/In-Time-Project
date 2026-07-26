import 'package:dio/dio.dart';
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
    final response = await dio.get('/my-notifications');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    await dio.put('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.put('/notifications/read-all');
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await dio.get('/notifications/unread-count');
    if (response.statusCode == 200) {
      return response.data['data']['count'];
    } else {
      throw Exception('Failed to load unread count');
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    await dio.post('/update-fcm-token', data: {'fcm_token': token});
  }
}

import 'dart:convert';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.isRead,
    required super.createdAt,
    super.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = {};
    if (json['data'] is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(json['data']);
    } else if (json['data'] is String) {
      try {
        data = jsonDecode(json['data']);
      } catch (_) {}
    }

    // Ensure type is in data for easier navigation handling
    if (json.containsKey('type') && !data.containsKey('type')) {
      data['type'] = json['type'];
    }

    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['read_at'] != null,
      createdAt: DateTime.parse(json['created_at']),
      data: data.isNotEmpty ? data : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'read_at': isRead ? DateTime.now().toIso8601String() : null,
      'created_at': createdAt.toIso8601String(),
      'data': data,
    };
  }
}

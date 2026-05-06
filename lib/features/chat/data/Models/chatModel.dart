// chat_model.dart

import '../../domain/entities/chatEntity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.senderName,
    required super.lastMessage,
    required super.profileUrl,
    required super.timestamp,
    required super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      senderName: json['senderName'],
      lastMessage: json['lastMessage'],
      profileUrl: json['profileUrl'],
      timestamp: DateTime.parse(json['timestamp']),
      unreadCount: json['unreadCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderName': senderName,
      'lastMessage': lastMessage,
      'profileUrl': profileUrl,
      'timestamp': timestamp.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }
}
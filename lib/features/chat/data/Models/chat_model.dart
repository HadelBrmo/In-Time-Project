import '../../domain/entities/chatEntity.dart';
import 'chat_user_model.dart';
import 'message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.type,
    super.name,
    super.createdBy,
    required super.unreadCount,
    super.latestMessage,
    super.otherUser,
    super.users,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int,
      type: json['type'] as String,
      name: json['name'] as String?,
      createdBy: json['created_by'] as int?,
      unreadCount: json['unread_count'] as int? ?? 0,
      latestMessage: json['latest_message'] != null
          ? MessageModel.fromJson(json['latest_message'] as Map<String, dynamic>)
          : null,
      otherUser: json['other_user'] != null
          ? ChatUserModel.fromJson(json['other_user'] as Map<String, dynamic>)
          : null,
      users: json['users'] != null
          ? (json['users'] as List).map((u) => ChatUserModel.fromJson(u as Map<String, dynamic>)).toList()
          : null,
    );
  }
}
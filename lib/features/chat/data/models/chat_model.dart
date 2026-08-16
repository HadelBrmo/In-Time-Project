import '../../domain/entities/chat_entity.dart';
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
    super.requestId,
    super.unitId
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
      requestId: json['request_id'] as int?,
      unitId: json['unit_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'created_by': createdBy,
      'unread_count': unreadCount,
      'latest_message': (latestMessage as MessageModel?)?.toJson(),
      'other_user': (otherUser as ChatUserModel?)?.toJson(),
      'users': users?.map((u) => (u as ChatUserModel).toJson()).toList(),
      'request_id': requestId,
      'unit_id': unitId,
    };
  }
}

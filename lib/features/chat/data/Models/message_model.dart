import '../../domain/entities/message_entity.dart';
import 'chat_user_model.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.createdAt,
    super.receivedCount,
    super.readCount,
    super.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      senderId: json['sender_id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      receivedCount: json['received_count'] as int?,
      readCount: json['read_count'] as int?,
      sender: json['sender'] != null
          ? ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'received_count': receivedCount,
      'read_count': readCount,
      'sender': (sender as ChatUserModel?)?.toJson(),
    };
  }
}
import 'package:equatable/equatable.dart';

import 'chatEntity.dart';

class MessageEntity extends Equatable {
  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final int? receivedCount;
  final int? readCount;
  final ChatUserEntity? sender;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.receivedCount,
    this.readCount,
    this.sender,
  });

  @override
  List<Object?> get props => [id, chatId, senderId, content, createdAt, receivedCount, readCount, sender];
}
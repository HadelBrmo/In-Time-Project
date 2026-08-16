import 'package:equatable/equatable.dart';

import 'message_entity.dart';

class ChatEntity extends Equatable {
  final int id;
  final String type;
  final String? name;
  final int? createdBy;
  final int unreadCount;
  final MessageEntity? latestMessage;
  final ChatUserEntity? otherUser;
  final List<ChatUserEntity>? users;

  const ChatEntity({
    required this.id,
    required this.type,
    this.name,
    this.createdBy,
    required this.unreadCount,
    this.latestMessage,
    this.otherUser,
    this.users,
  });

  @override
  List<Object?> get props => [id, type, name, createdBy, unreadCount, latestMessage, otherUser, users];
}

class ChatUserEntity extends Equatable {
  final int id;
  final String fullName;
  final String? profilePicture;
  final String? role;

  const ChatUserEntity({
    required this.id,
    required this.fullName,
    this.profilePicture,
    this.role,
  });

  @override
  List<Object?> get props => [id, fullName, profilePicture, role];
}

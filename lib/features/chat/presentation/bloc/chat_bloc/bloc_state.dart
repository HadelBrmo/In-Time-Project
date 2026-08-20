import 'package:equatable/equatable.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/message_entity.dart';


abstract class ChatState extends Equatable {
  final int totalUnreadCount;
  const ChatState({this.totalUnreadCount = 0});

  @override
  List<Object?> get props => [totalUnreadCount];
}

class ChatInitial extends ChatState {
  const ChatInitial({super.totalUnreadCount = 0});
}

class ChatsLoading extends ChatState {
  const ChatsLoading({super.totalUnreadCount = 0});
}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [chats, totalUnreadCount];
}

class ChatsError extends ChatState {
  final String message;
  const ChatsError(this.message, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [message, totalUnreadCount];
}

class ChatCreated extends ChatState {
  final ChatEntity chat;
  const ChatCreated(this.chat, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [chat, totalUnreadCount];
}

class MessagesLoading extends ChatState {
  const MessagesLoading({super.totalUnreadCount = 0});
}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [messages, totalUnreadCount];
}

class MessagesError extends ChatState {
  final String message;
  const MessagesError(this.message, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [message, totalUnreadCount];
}

class MessageSending extends ChatState {
  const MessageSending({super.totalUnreadCount = 0});
}

class MessageSent extends ChatState {
  final MessageEntity message;
  const MessageSent(this.message, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [message, totalUnreadCount];
}

class MembersLoading extends ChatState {
  const MembersLoading({super.totalUnreadCount = 0});
}

class MembersLoaded extends ChatState {
  final List<ChatUserEntity> members;
  const MembersLoaded(this.members, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [members, totalUnreadCount];
}

class MemberActionSuccess extends ChatState {
  final String message;
  const MemberActionSuccess(this.message, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [message, totalUnreadCount];
}

class ChatDraftLoaded extends ChatState {
  final String? draftText;
  const ChatDraftLoaded(this.draftText, {super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [draftText, totalUnreadCount];
}

class UserTypingState extends ChatState {
  final int userId;
  final String? userName;
  final bool isTyping;
  const UserTypingState({required this.userId, this.userName, required this.isTyping, super.totalUnreadCount = 0});

  @override
  List<Object?> get props => [userId, userName, isTyping, totalUnreadCount];
}

import '../../../domain/entities/chatEntity.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;
  final String? deletedChatId;

  ChatLoaded({required this.chats, this.deletedChatId});
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
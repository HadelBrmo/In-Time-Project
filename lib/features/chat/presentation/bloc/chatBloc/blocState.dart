import 'package:equatable/equatable.dart';

import '../../../domain/entities/chatEntity.dart';
import '../../../domain/entities/message_entity.dart';


abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatsLoading extends ChatState {}
class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}
class ChatsError extends ChatState {
  final String message;
  const ChatsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessagesLoading extends ChatState {}
class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageSending extends ChatState {}
class MessageSent extends ChatState {
  final MessageEntity message;
  const MessageSent(this.message);
}
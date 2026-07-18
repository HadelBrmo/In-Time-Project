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

class ChatCreated extends ChatState {
  final ChatEntity chat;
  const ChatCreated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatState {
  final String message;
  const MessagesError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {
  final MessageEntity message;
  const MessageSent(this.message);
}

class MembersLoading extends ChatState {}

class MembersLoaded extends ChatState {
  final List<ChatUserEntity> members;
  const MembersLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class MemberActionSuccess extends ChatState {
  final String message;
  const MemberActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatDraftLoaded extends ChatState {
  final String? draftText;
  const ChatDraftLoaded(this.draftText);

  @override
  List<Object?> get props => [draftText];
}

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetChatsEvent extends ChatEvent {
  final bool isSilent;
  const GetChatsEvent({this.isSilent = false});

  @override
  List<Object?> get props => [isSilent];
}

class GetMessagesEvent extends ChatEvent {
  final int chatId;
  final bool isSilent;
  const GetMessagesEvent(this.chatId, {this.isSilent = false});

  @override
  List<Object?> get props => [chatId, isSilent];
}

class SendMessageEvent extends ChatEvent {
  final int chatId;
  final String content;
  const SendMessageEvent(this.chatId, this.content);

  @override
  List<Object?> get props => [chatId, content];
}

class CreatePersonalChatEvent extends ChatEvent {
  final int receiverId;
  final String content;
  const CreatePersonalChatEvent(this.receiverId, this.content);
}

class CreateGroupChatEvent extends ChatEvent {
  final String name;
  final List<int> memberIds;

  const CreateGroupChatEvent({required this.name, required this.memberIds});

  @override
  List<Object> get props => [name, memberIds];
}
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

class ClearMessagesEvent extends ChatEvent {}

class MarkAsReadEvent extends ChatEvent {
  final int chatId;
  const MarkAsReadEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MarkAsReceivedEvent extends ChatEvent {
  final int chatId;
  const MarkAsReceivedEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class GetMembersEvent extends ChatEvent {
  final int chatId;
  const GetMembersEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class AddMembersEvent extends ChatEvent {
  final int chatId;
  final List<int> userIds;
  const AddMembersEvent(this.chatId, this.userIds);

  @override
  List<Object?> get props => [chatId, userIds];
}

class RemoveMemberEvent extends ChatEvent {
  final int chatId;
  final int userId;
  const RemoveMemberEvent(this.chatId, this.userId);

  @override
  List<Object?> get props => [chatId, userId];
}

class UpdateGroupEvent extends ChatEvent {
  final int chatId;
  final String name;
  const UpdateGroupEvent(this.chatId, this.name);

  @override
  List<Object?> get props => [chatId, name];
}

class LeaveGroupEvent extends ChatEvent {
  final int chatId;
  const LeaveGroupEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class LoadChatDraftEvent extends ChatEvent {
  final int chatId;
  const LoadChatDraftEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SaveChatDraftEvent extends ChatEvent {
  final int chatId;
  final String draftText;
  const SaveChatDraftEvent({required this.chatId, required this.draftText});

  @override
  List<Object?> get props => [chatId, draftText];
}

class StartTypingEvent extends ChatEvent {
  final int chatId;
  const StartTypingEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class StopTypingEvent extends ChatEvent {
  final int chatId;
  const StopTypingEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class OnNewMessageReceived extends ChatEvent {
  final dynamic messageData;
  const OnNewMessageReceived(this.messageData);

  @override
  List<Object?> get props => [messageData];
}

class OnUserTypingChanged extends ChatEvent {
  final dynamic typingData;
  const OnUserTypingChanged(this.typingData);

  @override
  List<Object?> get props => [typingData];
}

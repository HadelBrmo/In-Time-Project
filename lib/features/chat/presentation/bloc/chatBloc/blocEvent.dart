abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class SearchChatsEvent extends ChatEvent {
  final String query;
  SearchChatsEvent(this.query);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}

class UndoDeleteEvent extends ChatEvent {}
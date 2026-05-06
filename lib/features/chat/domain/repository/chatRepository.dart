import '../entities/chatEntity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> getChats();
  Future<void> deleteChat(String chatId);
  Future<List<ChatEntity>> searchChats(String query);
}
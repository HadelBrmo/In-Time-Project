import 'package:hive/hive.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatModel> chats);
  Future<List<ChatModel>> getCachedChats();

  Future<void> cacheMessages(int chatId, List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(int chatId);

  Future<void> saveChatDraft(int chatId, String draftText);
  Future<String?> getChatDraft(int chatId);
  Future<void> clearChatDraft(int chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _chatsBoxName = 'chats_box';
  static const String _messagesBoxName = 'messages_box';
  static const String _draftsBoxName = 'drafts_box';

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    final box = await Hive.openBox(_chatsBoxName);
    final List<Map<String, dynamic>> jsonList = chats.map((e) => e.toJson()).toList();
    await box.put('all_chats', jsonList);
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    final box = await Hive.openBox(_chatsBoxName);
    final List<dynamic>? jsonList = box.get('all_chats');
    if (jsonList != null) {
      return jsonList.map((json) => ChatModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  @override
  Future<void> cacheMessages(int chatId, List<MessageModel> messages) async {
    final box = await Hive.openBox(_messagesBoxName);
    final List<Map<String, dynamic>> jsonList = messages.map((e) => e.toJson()).toList();
    await box.put(chatId.toString(), jsonList);
  }

  @override
  Future<List<MessageModel>> getCachedMessages(int chatId) async {
    final box = await Hive.openBox(_messagesBoxName);
    final List<dynamic>? jsonList = box.get(chatId.toString());
    if (jsonList != null) {
      return jsonList.map((json) => MessageModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }

  @override
  Future<void> saveChatDraft(int chatId, String draftText) async {
    final box = await Hive.openBox(_draftsBoxName);
    await box.put(chatId.toString(), draftText);
  }

  @override
  Future<String?> getChatDraft(int chatId) async {
    final box = await Hive.openBox(_draftsBoxName);
    return box.get(chatId.toString()) as String?;
  }

  @override
  Future<void> clearChatDraft(int chatId) async {
    final box = await Hive.openBox(_draftsBoxName);
    await box.delete(chatId.toString());
  }
}

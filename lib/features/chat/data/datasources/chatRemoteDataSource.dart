import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/chat_user_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> createPersonalChat(int receiverId, String content);
  Future<ChatModel> createGroupChat(String name, List<int> memberIds);
  Future<void> updateGroup(int chatId, String name);
  Future<List<MessageModel>> getMessages(int chatId);
  Future<MessageModel> sendMessage(int chatId, String content);
  Future<void> markAsRead(int chatId);
  Future<void> markAsReceived(int chatId);
  Future<List<ChatUserModel>> getMembers(int chatId);
  Future<void> addMembers(int chatId, List<int> userIds);
  Future<void> removeMember(int chatId, int userId);
  Future<void> leaveGroup(int chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await dio.get(ApiStringConstants.chatsUrl);
    final List data = response.data['data'];
    return data.map((json) => ChatModel.fromJson(json)).toList();
  }

  @override
  Future<ChatModel> createPersonalChat(int receiverId, String content) async {
    final response = await dio.post(ApiStringConstants.chatsUrl, data: {
      'type': 'personal',
      'receiver_id': receiverId,
      'content': content,
    });
    return ChatModel.fromJson(response.data['data']);
  }

  @override
  Future<ChatModel> createGroupChat(String name, List<int> memberIds) async {
    final response = await dio.post(ApiStringConstants.chatsUrl, data: {
      'type': 'group',
      'name': name,
      'member_ids': memberIds,
    });
    return ChatModel.fromJson(response.data['data']['chat']);
  }

  @override
  Future<void> updateGroup(int chatId, String name) async {
    await dio.put(ApiStringConstants.updateGroupUrl(chatId), data: {'name': name});
  }

  @override
  Future<List<MessageModel>> getMessages(int chatId) async {
    final response = await dio.get(ApiStringConstants.messagesUrl(chatId));
    final List data = response.data['data'];
    return data.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<MessageModel> sendMessage(int chatId, String content) async {
    final response = await dio.post(ApiStringConstants.messagesUrl(chatId), data: {'content': content});
    return MessageModel.fromJson(response.data['data']['message']);
  }

  @override
  Future<void> markAsRead(int chatId) async {
    await dio.put(ApiStringConstants.markAsReadUrl(chatId));
  }

  @override
  Future<void> markAsReceived(int chatId) async {
    await dio.put(ApiStringConstants.markAsReceivedUrl(chatId));
  }

  @override
  Future<List<ChatUserModel>> getMembers(int chatId) async {
    final response = await dio.get(ApiStringConstants.membersUrl(chatId));
    final List data = response.data['data'];
    return data.map((json) => ChatUserModel.fromJson(json)).toList();
  }

  @override
  Future<void> addMembers(int chatId, List<int> userIds) async {
    await dio.post(ApiStringConstants.membersUrl(chatId), data: {'user_ids': userIds});
  }

  @override
  Future<void> removeMember(int chatId, int userId) async {
    await dio.delete(ApiStringConstants.removeMemberUrl(chatId, userId));
  }

  @override
  Future<void> leaveGroup(int chatId) async {
    await dio.post(ApiStringConstants.leaveGroupUrl(chatId));
  }
}
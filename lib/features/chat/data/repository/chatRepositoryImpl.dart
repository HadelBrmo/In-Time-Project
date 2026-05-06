// chat_repository_impl.dart


import '../../domain/entities/chatEntity.dart';
import '../../domain/repository/chatRepository.dart';
import '../datasources/chatRemoteDataSource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatEntity>> getChats() async {

    return await remoteDataSource.getChats();
  }

  @override
  Future<void> deleteChat(String chatId) async {
    print("Chat $chatId deleted from mock server");
  }

  @override
  Future<List<ChatEntity>> searchChats(String query) async {
    final allChats = await remoteDataSource.getChats();
    return allChats.where((chat) =>
        chat.senderName.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
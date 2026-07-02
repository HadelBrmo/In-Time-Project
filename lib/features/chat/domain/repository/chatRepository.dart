import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chatEntity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // Chats operations
  Future<Either<Failure, List<ChatEntity>>> getChats();
  Future<Either<Failure, ChatEntity>> createPersonalChat(int receiverId, String content);
  Future<Either<Failure, ChatEntity>> createGroupChat(String name, List<int> memberIds);
  Future<Either<Failure, Unit>> updateGroup(int chatId, String name);

  // Messages operations
  Future<Either<Failure, List<MessageEntity>>> getMessages(int chatId);
  Future<Either<Failure, MessageEntity>> sendMessage(int chatId, String content);
  Future<Either<Failure, Unit>> markAsRead(int chatId);
  Future<Either<Failure, Unit>> markAsReceived(int chatId);

  // Members operations
  Future<Either<Failure, List<ChatUserEntity>>> getMembers(int chatId);
  Future<Either<Failure, Unit>> addMembers(int chatId, List<int> userIds);
  Future<Either<Failure, Unit>> removeMember(int chatId, int userId);
  Future<Either<Failure, Unit>> leaveGroup(int chatId);
}
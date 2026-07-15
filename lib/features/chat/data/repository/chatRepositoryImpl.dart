import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/chatEntity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repository/chatRepository.dart';
import '../datasources/chatRemoteDataSource.dart';
import '../datasources/chat_local_data_source.dart';


class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final remoteChats = await remoteDataSource.getChats();
      await localDataSource.cacheChats(remoteChats);
      return Right(remoteChats);
    } catch (e) {
      final localChats = await localDataSource.getCachedChats();
      if (localChats.isNotEmpty) {
        return Right(localChats);
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createPersonalChat(int receiverId, String content) async {
    try {
      final chat = await remoteDataSource.createPersonalChat(receiverId, content);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createGroupChat(String name, List<int> memberIds) async {
    try {
      final chat = await remoteDataSource.createGroupChat(name, memberIds);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGroup(int chatId, String name) async {
    try {
      await remoteDataSource.updateGroup(chatId, name);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(int chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      await localDataSource.cacheMessages(chatId, messages);
      return Right(messages);
    } catch (e) {
      final localMessages = await localDataSource.getCachedMessages(chatId);
      if (localMessages.isNotEmpty) {
        return Right(localMessages);
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(int chatId, String content) async {
    try {
      final message = await remoteDataSource.sendMessage(chatId, content);
      return Right(message);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(int chatId) async {
    try {
      await remoteDataSource.markAsRead(chatId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsReceived(int chatId) async {
    try {
      await remoteDataSource.markAsReceived(chatId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatUserEntity>>> getMembers(int chatId) async {
    try {
      final members = await remoteDataSource.getMembers(chatId);
      return Right(members);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addMembers(int chatId, List<int> userIds) async {
    try {
      await remoteDataSource.addMembers(chatId, userIds);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeMember(int chatId, int userId) async {
    try {
      await remoteDataSource.removeMember(chatId, userId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> leaveGroup(int chatId) async {
    try {
      await remoteDataSource.leaveGroup(chatId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
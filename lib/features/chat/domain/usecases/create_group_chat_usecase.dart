import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chatEntity.dart';
import '../repository/chat_repository.dart';


class CreateGroupChatUseCase {
  final ChatRepository repository;

  CreateGroupChatUseCase(this.repository);

  Future<Either<Failure, ChatEntity>> call({required String name, required List<int> memberIds}) async {
    return await repository.createGroupChat(name, memberIds);
  }
}
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';

class GetMembersUseCase {
  final ChatRepository repository;

  GetMembersUseCase(this.repository);

  Future<Either<Failure, List<ChatUserEntity>>> call(int chatId) async {
    return await repository.getMembers(chatId);
  }
}

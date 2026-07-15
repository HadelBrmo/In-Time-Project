import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chatEntity.dart';
import '../repository/chatRepository.dart';

class GetMembersUseCase {
  final ChatRepository repository;

  GetMembersUseCase(this.repository);

  Future<Either<Failure, List<ChatUserEntity>>> call(int chatId) async {
    return await repository.getMembers(chatId);
  }
}

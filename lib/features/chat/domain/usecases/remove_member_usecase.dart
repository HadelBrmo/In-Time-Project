import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chatRepository.dart';

class RemoveMemberUseCase {
  final ChatRepository repository;

  RemoveMemberUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId, int userId) async {
    return await repository.removeMember(chatId, userId);
  }
}

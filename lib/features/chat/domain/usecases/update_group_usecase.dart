import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chat_repository.dart';

class UpdateGroupUseCase {
  final ChatRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId, String name) async {
    return await repository.updateGroup(chatId, name);
  }
}

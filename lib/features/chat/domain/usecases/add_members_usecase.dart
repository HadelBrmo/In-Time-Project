import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chat_repository.dart';

class AddMembersUseCase {
  final ChatRepository repository;

  AddMembersUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId, List<int> userIds) async {
    return await repository.addMembers(chatId, userIds);
  }
}

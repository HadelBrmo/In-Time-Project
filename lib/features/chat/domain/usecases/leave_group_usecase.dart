import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chatRepository.dart';

class LeaveGroupUseCase {
  final ChatRepository repository;

  LeaveGroupUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.leaveGroup(chatId);
  }
}
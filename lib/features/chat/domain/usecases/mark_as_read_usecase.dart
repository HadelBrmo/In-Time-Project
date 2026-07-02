import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chatRepository.dart';

class MarkAsReadUseCase {
  final ChatRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.markAsRead(chatId);
  }
}
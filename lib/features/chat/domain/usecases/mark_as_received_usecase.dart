import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chatRepository.dart';

class MarkAsReceivedUseCase {
  final ChatRepository repository;

  MarkAsReceivedUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.markAsReceived(chatId);
  }
}
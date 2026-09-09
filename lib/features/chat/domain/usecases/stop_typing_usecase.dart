import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chat_repository.dart';

class StopTypingUseCase {
  final ChatRepository repository;

  StopTypingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.stopTypingIndicator(chatId);
  }
}

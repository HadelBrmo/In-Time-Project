import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chat_repository.dart';

class SendTypingUseCase {
  final ChatRepository repository;

  SendTypingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.sendTypingIndicator(chatId);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/chat_repository.dart';

class DeleteChatUseCase {
  final ChatRepository repository;
  DeleteChatUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int chatId) async {
    return await repository.deleteChat(chatId);
  }
}

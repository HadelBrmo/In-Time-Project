import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';


class CreatePersonalChatUseCase {
  final ChatRepository repository;

  CreatePersonalChatUseCase(this.repository);

  Future<Either<Failure, ChatEntity>> call({required int receiverId, required String content}) async {
    return await repository.createPersonalChat(receiverId, content);
  }
}
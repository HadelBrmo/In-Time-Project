import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';

class SearchChatsUseCase {
  final ChatRepository repository;
  SearchChatsUseCase(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call(String query) async {
    return await repository.searchChats(query);
  }
}

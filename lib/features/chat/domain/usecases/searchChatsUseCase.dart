import '../entities/chatEntity.dart';
import '../repository/chatRepository.dart';

class SearchChatsUseCase {
  final ChatRepository repository;
  SearchChatsUseCase(this.repository);

  Future<List<ChatEntity>> call(String query) async {
    return await repository.searchChats(query);
  }
}
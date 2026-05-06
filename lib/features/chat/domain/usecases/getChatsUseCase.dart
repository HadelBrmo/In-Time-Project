import '../entities/chatEntity.dart';
import '../repository/chatRepository.dart';

class GetChatsUseCase {
  final ChatRepository repository;
  GetChatsUseCase(this.repository,);

  Future<List<ChatEntity>> call() async {
    return await repository.getChats();
  }
}
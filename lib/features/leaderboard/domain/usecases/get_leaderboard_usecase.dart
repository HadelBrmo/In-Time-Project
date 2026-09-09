import '../entities/leaderboard_user_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetLeaderboardUseCase {
  final LeaderboardRepository repository;
  GetLeaderboardUseCase(this.repository);

  Future<List<LeaderboardUserEntity>> call({
    int? servingTypeId,
    required String month,
  }) {
    return repository.getTopPerformers(servingTypeId: servingTypeId, month: month);
  }
}

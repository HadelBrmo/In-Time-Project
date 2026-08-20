import '../entities/leaderboard_user_entity.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardUserEntity>> getTopPerformers({
    int? servingTypeId,
    required String month,
  });
}

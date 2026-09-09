import '../../domain/entities/leaderboard_user_entity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_data_source.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  LeaderboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LeaderboardUserEntity>> getTopPerformers({
    int? servingTypeId,
    required String month,
  }) {
    return remoteDataSource.getTopPerformers(servingTypeId: servingTypeId, month: month);
  }
}

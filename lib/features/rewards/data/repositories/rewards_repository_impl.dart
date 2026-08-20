import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_remote_data_source.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource remoteDataSource;

  RewardsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<RewardEntity>>> getMyRewards() async {
    try {
      final remoteRewards = await remoteDataSource.getMyRewards();
      return Success(remoteRewards);
    } catch (e) {
      return const FailureResult(ServerFailure('Failed to fetch rewards'));
    }
  }
}

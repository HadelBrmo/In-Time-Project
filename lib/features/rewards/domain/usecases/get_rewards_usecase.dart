import '../../../../core/network/api_result.dart';
import '../entities/reward_entity.dart';
import '../repositories/rewards_repository.dart';

class GetRewardsUseCase {
  final RewardsRepository repository;

  GetRewardsUseCase(this.repository);

  Future<ApiResult<(List<RewardEntity>, int)>> call() async {
    return await repository.getMyRewards();
  }
}

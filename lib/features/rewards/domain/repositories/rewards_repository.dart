import '../../../../core/network/api_result.dart';
import '../entities/reward_entity.dart';

abstract class RewardsRepository {
  Future<ApiResult<(List<RewardEntity>, int)>> getMyRewards();
}

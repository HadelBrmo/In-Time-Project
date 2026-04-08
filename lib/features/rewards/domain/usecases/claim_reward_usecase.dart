import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reward_entity.dart';

class ClaimRewardUseCase implements UseCase<void, ClaimParams> {
  @override
  Future<Either<Failure, void>> call(ClaimParams params) async {
    throw UnimplementedError();
  }
}

class ClaimParams {
  final String rewardId;

  ClaimParams({required this.rewardId});
}
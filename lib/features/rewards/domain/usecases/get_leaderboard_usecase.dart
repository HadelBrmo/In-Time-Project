import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/no_params.dart';
import '../entities/leaderboard_user_entity.dart';

class GetLeaderboardUseCase implements UseCase<List<LeaderboardUserEntity>, NoParams> {
  @override
  Future<Either<Failure, List<LeaderboardUserEntity>>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
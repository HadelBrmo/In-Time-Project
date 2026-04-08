import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/no_params.dart';
import '../entities/badge_entity.dart';

class GetUserBadgesUseCase implements UseCase<List<BadgeEntity>, NoParams> {
  @override
  Future<Either<Failure, List<BadgeEntity>>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
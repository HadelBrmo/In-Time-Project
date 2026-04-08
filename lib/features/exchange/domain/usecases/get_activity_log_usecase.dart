import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/no_params.dart';
import '../entities/activity_log_entity.dart';

class GetActivityLogUseCase implements UseCase<List<ActivityLogEntity>, NoParams> {
  @override
  Future<Either<Failure, List<ActivityLogEntity>>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
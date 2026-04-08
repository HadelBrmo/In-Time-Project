import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/no_params.dart';
import '../entities/hours_balance_entity.dart';

class GetHoursBalanceUseCase implements UseCase<HoursBalanceEntity, NoParams> {
  @override
  Future<Either<Failure, HoursBalanceEntity>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
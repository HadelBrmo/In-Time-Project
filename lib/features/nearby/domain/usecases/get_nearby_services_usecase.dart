import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/usecase/no_params.dart';

class GetNearbyServicesUseCase implements UseCase<List<ServiceEntity>, NoParams> {
  @override
  Future<Either<Failure, List<ServiceEntity>>> call(NoParams params) async {
    throw UnimplementedError();
  }
}
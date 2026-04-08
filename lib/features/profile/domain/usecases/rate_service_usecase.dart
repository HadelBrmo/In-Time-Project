import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class RateServiceUseCase implements UseCase<void, RateParams> {
  @override
  Future<Either<Failure, void>> call(RateParams params) async {
    throw UnimplementedError();
  }
}

class RateParams {
  final String serviceId;
  final double rating;

  RateParams({required this.serviceId, required this.rating});
}
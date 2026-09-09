import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../repository/services_repository.dart';

class RateServingUseCase {
  final ServicesRepository repository;

  RateServingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int serviceId, double rating) async {
    return await repository.rateServing(serviceId, rating);
  }
}

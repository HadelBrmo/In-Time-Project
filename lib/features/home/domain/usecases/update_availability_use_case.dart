import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class UpdateAvailabilityUseCase {
  final HomeRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int serviceId,
    required Map<String, dynamic> data,
  }) async {
    return await repository.updateServiceAvailability(serviceId: serviceId, data: data);
  }
}
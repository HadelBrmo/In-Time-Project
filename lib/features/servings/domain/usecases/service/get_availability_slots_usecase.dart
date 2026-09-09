import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repository/services_repository.dart';

class GetAvailabilitySlotsUseCase {
  final ServicesRepository repository;

  GetAvailabilitySlotsUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call(int serviceId) async {
    return await repository.getAvailabilitySlots(serviceId);
  }
}

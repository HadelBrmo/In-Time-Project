import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/service_entity.dart';
import '../../repository/services_repository.dart';

class GetServiceDetailsUseCase {
  final ServicesRepository repository;

  GetServiceDetailsUseCase(this.repository);

  Future<Either<Failure, ServiceEntity>> call(int serviceId) async {
    return await repository.getServiceDetails(serviceId);
  }
}

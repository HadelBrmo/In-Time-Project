import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/service_entity.dart';
import '../../repository/services_repository.dart';

class GetMyServingsUseCase {
  final ServicesRepository repository;

  GetMyServingsUseCase(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getMyServings();
  }
}

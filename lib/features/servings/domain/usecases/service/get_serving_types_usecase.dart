import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/serving_type_entity.dart';
import '../../repository/services_repository.dart';

class GetServingTypesUseCase {
  final ServicesRepository repository;

  GetServingTypesUseCase(this.repository);

  Future<Either<Failure, List<ServingTypeEntity>>> call() async {
    return await repository.getServingTypes();
  }
}

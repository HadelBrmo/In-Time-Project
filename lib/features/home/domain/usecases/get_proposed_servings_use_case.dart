import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../servings/domain/entity/service_entity.dart';
import '../repositories/home_repository.dart';

class GetProposedServingsUseCase {
  final HomeRepository repository;

  GetProposedServingsUseCase(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call({
    required int skip,
    required int take,
  }) async {
    return await repository.getProposedServings(
      skip: skip,
      take: take,
    );
  }
}

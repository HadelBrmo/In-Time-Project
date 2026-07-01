import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../servings/domain/entity/service_entity.dart';
import '../repositories/home_repository.dart';

class GetNearbyServingsUseCase {
  final HomeRepository repository;

  GetNearbyServingsUseCase(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  }) async {
    return await repository.getNearbyServings(
      lat: lat,
      lng: lng,
      skip: skip,
      take: take,
    );
  }
}

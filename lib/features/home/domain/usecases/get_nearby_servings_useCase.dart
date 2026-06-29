// lib/features/home/domain/usecases/get_nearby_servings_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/home_repository.dart';


class GetNearbyServingsUseCase {
  final HomeRepository repository;

  GetNearbyServingsUseCase(this.repository);

  Future<Either<Failure, List<ServicingEntity>>> call({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  }) {
    return repository.getNearbyServings(lat: lat, lng: lng, skip: skip, take: take);
  }
}

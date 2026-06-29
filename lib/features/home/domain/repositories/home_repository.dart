import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ServicingEntity>>> searchServings({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
    int? skip,
    int? take,
  });
  Future<Either<Failure, List<ServicingEntity>>> getNearbyServings({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  });
}

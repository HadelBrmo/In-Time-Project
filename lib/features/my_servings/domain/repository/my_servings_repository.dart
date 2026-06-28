// lib/features/my_servings/domain/repository/my_servings_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/my_serving_entity.dart';

abstract class MyServingsRepository {
  Future<Either<Failure, List<MyServingEntity>>> getMyServings();

  Future<Either<Failure, Unit>> updateServing({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  });
}
// lib/features/my_servings/domain/usecase/get_my_servings_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/my_serving_entity.dart';
import '../repository/my_servings_repository.dart';

class GetMyServingsUseCase {
  final MyServingsRepository repository;
  GetMyServingsUseCase(this.repository);

  Future<Either<Failure, List<MyServingEntity>>> call() async {
    return await repository.getMyServings();
  }
}
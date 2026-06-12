import 'package:dartz/dartz.dart';
import '../entities/service_entity.dart';
import '../repositories/home_repository.dart';

class SearchServingsUseCase {
  final HomeRepository repository;

  SearchServingsUseCase(this.repository);

  Future<List<ServicingEntity>> call({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
  }) async {
    final result = await repository.searchServings(
      servingTypeId: servingTypeId,
      paymentUnitId: paymentUnitId,
      servingCategoryId: servingCategoryId,
      name: name,
    );

    return result.fold(
          (failure) => throw failure,
          (servings) => servings,
    );
  }
}
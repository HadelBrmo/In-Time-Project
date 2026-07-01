import '../../../servings/domain/entity/service_entity.dart';
import '../repositories/home_repository.dart';

class SearchServingsUseCase {
  final HomeRepository repository;

  SearchServingsUseCase(this.repository);

  Future<List<ServiceEntity>> call({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
    int? skip,
    int? take,
  }) async {
    final result = await repository.searchServings(
      servingTypeId: servingTypeId,
      paymentUnitId: paymentUnitId,
      servingCategoryId: servingCategoryId,
      name: name,
      skip: skip,
      take: take,
    );

    return result.fold(
          (failure) => throw failure,
          (servings) => servings,
    );
  }
}

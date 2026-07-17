import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/category_entity.dart';
import '../../repository/servicesRepository.dart';

class GetCategoriesUseCase {
  final ServicesRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getCategories();
  }
}

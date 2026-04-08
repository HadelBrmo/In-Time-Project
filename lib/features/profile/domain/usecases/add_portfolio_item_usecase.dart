import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/portfolio_item_entity.dart';

class AddPortfolioItemUseCase implements UseCase<PortfolioItemEntity, AddItemParams> {
  @override
  Future<Either<Failure, PortfolioItemEntity>> call(AddItemParams params) async {
    throw UnimplementedError();
  }
}

class AddItemParams {
  final PortfolioItemEntity item;

  AddItemParams({required this.item});
}
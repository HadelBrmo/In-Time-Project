import '../../../../core/network/api_result.dart';
import '../entities/portfolio_item_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetPortfolioUseCase {
  final IProfileRepository repository;

  GetPortfolioUseCase(this.repository);

  Future<ApiResult<List<PortfolioItemEntity>>> call(int userId) async {
    return await repository.getPortfolio(userId);
  }
}

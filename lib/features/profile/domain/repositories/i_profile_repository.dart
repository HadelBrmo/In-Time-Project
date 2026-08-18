import '../../../../core/network/api_result.dart';
import '../entities/portfolio_item_entity.dart';
import '../entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<ApiResult<UserProfile>> getUserProfile(int userId);
  Future<ApiResult<UserProfile>> updateProfile(Map<String, dynamic> profileData);
  Future<ApiResult<List<PortfolioItemEntity>>> getPortfolio(int userId);
}

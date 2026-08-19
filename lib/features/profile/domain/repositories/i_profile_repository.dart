import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_result.dart';
import '../entities/portfolio_item_entity.dart';
import '../entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<ApiResult<UserProfile>> getUserProfile(int userId);
  Future<ApiResult<UserProfile>> updateProfile(Map<String, dynamic> profileData);
  Future<ApiResult<List<PortfolioItemEntity>>> getPortfolio(int userId);
  Future<ApiResult<void>> uploadPortfolioImage({
    required int userId,
    required XFile image,
    required String title,
  });
  Future<ApiResult<void>> uploadPortfolioFile({
    required int userId,
    required PlatformFile file,
    required String title,
  });
  Future<ApiResult<void>> uploadPortfolioLink({
    required int userId,
    required String url,
    required String title,
  });
}

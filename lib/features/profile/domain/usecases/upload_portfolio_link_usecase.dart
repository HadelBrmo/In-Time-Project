import '../../../../core/network/api_result.dart';
import '../repositories/i_profile_repository.dart';

class UploadPortfolioLinkUseCase {
  final IProfileRepository repository;

  UploadPortfolioLinkUseCase(this.repository);

  Future<ApiResult<void>> call({
    required int userId,
    required String url,
    required String title,
  }) async {
    return await repository.uploadPortfolioLink(
      userId: userId,
      url: url,
      title: title,
    );
  }
}

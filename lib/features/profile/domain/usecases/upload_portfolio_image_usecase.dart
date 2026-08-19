import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_result.dart';
import '../repositories/i_profile_repository.dart';

class UploadPortfolioImageUseCase {
  final IProfileRepository repository;

  UploadPortfolioImageUseCase(this.repository);

  Future<ApiResult<void>> call({
    required int userId,
    required XFile image,
    required String title,
  }) async {
    return await repository.uploadPortfolioImage(
      userId: userId,
      image: image,
      title: title,
    );
  }
}

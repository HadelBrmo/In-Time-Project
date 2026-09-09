import 'package:file_picker/file_picker.dart';
import '../../../../core/network/api_result.dart';
import '../repositories/i_profile_repository.dart';

class UploadPortfolioFileUseCase {
  final IProfileRepository repository;

  UploadPortfolioFileUseCase(this.repository);

  Future<ApiResult<void>> call({
    required int userId,
    required PlatformFile file,
    required String title,
  }) async {
    return await repository.uploadPortfolioFile(
      userId: userId,
      file: file,
      title: title,
    );
  }
}

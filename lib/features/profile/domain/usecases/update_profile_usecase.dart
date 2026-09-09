import '../../../../core/network/api_result.dart';
import '../entities/profile_entity.dart';
import '../repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<ApiResult<UserProfile>> call(Map<String, dynamic> profileData) async {
    return await repository.updateProfile(profileData);
  }
}

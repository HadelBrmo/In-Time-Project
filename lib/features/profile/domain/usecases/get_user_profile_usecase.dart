import '../../../../core/network/api_result.dart';
import '../entities/profile_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetUserProfileUseCase {
  final IProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<ApiResult<UserProfile>> call(int userId) async {
    return await repository.getUserProfile(userId);
  }
}

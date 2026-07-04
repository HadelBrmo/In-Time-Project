import '../repositories/i_profile_repository.dart';
import '../../data/models/user_profile_model.dart';

class GetUserProfileUseCase {
  final IProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call(int userId) async {
    return await repository.getUserProfile(userId);
  }
}

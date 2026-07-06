import '../repositories/i_profile_repository.dart';
import '../../data/models/user_profile_model.dart';

class UpdateProfileUseCase {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserProfile> call(Map<String, dynamic> profileData) async {
    return await repository.updateProfile(profileData);
  }
}

import '../../data/models/user_profile_model.dart';

abstract class IProfileRepository {
  Future<UserProfile> getUserProfile(int userId);
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData);
}

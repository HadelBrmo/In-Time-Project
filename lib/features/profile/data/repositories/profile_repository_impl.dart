import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    final profile = await remoteDataSource.getUserProfile(userId);
    await _saveProfileLocally(profile);
    return profile;
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    final updatedProfile = await remoteDataSource.updateProfile(profileData);
    await _saveProfileLocally(updatedProfile);
    return updatedProfile;
  }

  Future<void> _saveProfileLocally(UserProfile profile) async {
    await sharedPreferences.setString("full_name", profile.fullName);
    await sharedPreferences.setString("email", profile.email);
    if (profile.profilePicture != null) {
      await sharedPreferences.setString("profile_picture", profile.profilePicture!);
    }
  }
}

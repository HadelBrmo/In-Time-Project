import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfile(UserProfile profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await sharedPreferences.setString("full_name", profile.fullName);
    await sharedPreferences.setString("email", profile.email);
    if (profile.profilePicture != null) {
      await sharedPreferences.setString("profile_picture", profile.profilePicture!);
    }
  }
}

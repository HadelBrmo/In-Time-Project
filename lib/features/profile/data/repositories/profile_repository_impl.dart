import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    final profile = await remoteDataSource.getUserProfile(userId);
    await localDataSource.saveProfile(profile);
    return profile;
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    final updatedProfile = await remoteDataSource.updateProfile(profileData);
    await localDataSource.saveProfile(updatedProfile);
    return updatedProfile;
  }
}

import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    return await remoteDataSource.getUserProfile(userId);
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    return await remoteDataSource.updateProfile(profileData);
  }
}

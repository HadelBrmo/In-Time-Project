import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ApiResult<UserProfile>> getUserProfile(int userId) async {
    try {
      final profile = await remoteDataSource.getUserProfile(userId);
      await localDataSource.saveProfile(profile);
      return Success(profile);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }

  @override
  Future<ApiResult<UserProfile>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final updatedProfile = await remoteDataSource.updateProfile(profileData);
      await localDataSource.saveProfile(updatedProfile);
      return Success(updatedProfile);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }

  @override
  Future<ApiResult<List<PortfolioItemEntity>>> getPortfolio(int userId) async {
    try {
      final portfolio = await remoteDataSource.getPortfolio(userId);
      return Success(portfolio);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }
}

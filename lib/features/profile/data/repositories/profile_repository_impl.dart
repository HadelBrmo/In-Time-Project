import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/portfolio_remote_data_source.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final PortfolioRemoteDataSource portfolioRemoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.portfolioRemoteDataSource,
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

  @override
  Future<ApiResult<void>> uploadPortfolioImage({
    required int userId,
    required XFile image,
    required String title,
  }) async {
    try {
      await portfolioRemoteDataSource.uploadImage(
        userId: userId,
        image: image,
        title: title,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }

  @override
  Future<ApiResult<void>> uploadPortfolioFile({
    required int userId,
    required PlatformFile file,
    required String title,
  }) async {
    try {
      await portfolioRemoteDataSource.uploadFile(
        userId: userId,
        file: file,
        title: title,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }

  @override
  Future<ApiResult<void>> uploadPortfolioLink({
    required int userId,
    required String url,
    required String title,
  }) async {
    try {
      await portfolioRemoteDataSource.uploadLink(
        userId: userId,
        url: url,
        title: title,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(ServerFailure());
    }
  }
}

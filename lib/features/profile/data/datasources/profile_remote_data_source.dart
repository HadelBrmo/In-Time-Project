import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/portfolio_item_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(int userId);
  Future<UserProfileModel> updateProfile(Map<String, dynamic> profileData);
  Future<List<PortfolioItemModel>> getPortfolio(int userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getUserProfile(int userId) async {
    try {
      final response = await dio.get(ApiStringConstants.userProfileUrl(userId));
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(profileData);
      
      if (map.containsKey('profile_picture_path') && map['profile_picture_path'] != null) {
        String path = map['profile_picture_path'];
        map['profile_picture'] = await MultipartFile.fromFile(path, filename: path.split('/').last);
        map.remove('profile_picture_path');
      }

      final formData = FormData.fromMap(map);

      final response = await dio.post(ApiStringConstants.updateProfileUrl, data: formData);
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<PortfolioItemModel>> getPortfolio(int userId) async {
    try {
      final response = await dio.get("work-gallery/user/$userId");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PortfolioItemModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

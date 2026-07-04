import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getUserProfile(int userId);
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    try {
      // نزيد وقت الانتظار قليلاً لأن السيرفر يبدو بطيئاً في بعض الحسابات
      final response = await dio.get(
        '/users/$userId',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      // إذا رجع السيرفر 502 أو Timeout
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    try {
      // تحويل البيانات إلى FormData لتطابق البوست مان وتدعم رفع الصور
      final Map<String, dynamic> map = Map<String, dynamic>.from(profileData);
      
      // إذا كان هناك مسار صورة، نحوله لـ MultipartFile
      if (map.containsKey('profile_picture_path') && map['profile_picture_path'] != null) {
        String path = map['profile_picture_path'];
        map['profile_picture'] = await MultipartFile.fromFile(path, filename: path.split('/').last);
        map.remove('profile_picture_path');
      }

      final formData = FormData.fromMap(map);

      final response = await dio.post('/profile', data: formData);
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}

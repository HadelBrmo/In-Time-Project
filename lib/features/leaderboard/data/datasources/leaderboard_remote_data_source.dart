import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/leaderboard_user_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardUserModel>> getTopPerformers({
    int? servingTypeId,
    required String month,
  });
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final Dio dio;
  LeaderboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LeaderboardUserModel>> getTopPerformers({
    int? servingTypeId,
    required String month,
  }) async {
    try {
      final response = await dio.post(
        ApiStringConstants.topPerformersUrl,
        data: {
          if (servingTypeId != null) 'serving_type_id': servingTypeId,
          'month': month,
        },
      );
      if (response.statusCode == 200) {
        final dynamic responseData = response.data['data'];
        if (responseData == null || !(responseData is List)) {
          return [];
        }
        return responseData.map((json) => LeaderboardUserModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print("❌ [LeaderboardRemoteDataSource] DioException: ${e.message}");
      if (e.response != null) {
        print("📦 Response Data: ${e.response?.data}");
      }
      throw ServerException();
    } catch (e) {
      print("❌ [LeaderboardRemoteDataSource] Unexpected Error: $e");
      throw ServerException();
    }
  }
}

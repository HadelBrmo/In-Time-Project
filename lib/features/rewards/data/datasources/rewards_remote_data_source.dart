import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reward_model.dart';

abstract class RewardsRemoteDataSource {
  Future<(List<RewardModel>, int)> getMyRewards();
}

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final Dio dio;

  RewardsRemoteDataSourceImpl({required this.dio});

  @override
  Future<(List<RewardModel>, int)> getMyRewards() async {
    try {
      print("🚀 [RewardsRemoteDataSource] Fetching rewards from: ${ApiStringConstants.myRewardsUrl}");
      final response = await dio.get(ApiStringConstants.myRewardsUrl);
      
      print("📦 [RewardsRemoteDataSource] Response status: ${response.statusCode}");
      print("📦 [RewardsRemoteDataSource] Response data: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        final int totalHoursAdded = response.data['total_hours_added'] ?? 0;
        
        final rewards = dataList.map((json) => RewardModel.fromJson(json)).toList();
        print("✅ [RewardsRemoteDataSource] Parsed ${rewards.length} rewards. Total hours: $totalHoursAdded");
        
        return (rewards, totalHoursAdded);
      } else {
        print("❌ [RewardsRemoteDataSource] Unexpected status code: ${response.statusCode}");
        throw ServerException();
      }
    } on DioException catch (e) {
      print("❌ [RewardsRemoteDataSource] DioException: ${e.message}");
      if (e.response != null) {
        print("📦 [RewardsRemoteDataSource] Response Data: ${e.response?.data}");
      }
      throw ServerException();
    } catch (e) {
      print("❌ [RewardsRemoteDataSource] Error: $e");
      throw ServerException();
    }
  }
}

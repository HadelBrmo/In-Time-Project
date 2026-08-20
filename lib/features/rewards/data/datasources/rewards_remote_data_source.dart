import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reward_model.dart';

abstract class RewardsRemoteDataSource {
  Future<List<RewardModel>> getMyRewards();
}

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final Dio dio;

  RewardsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RewardModel>> getMyRewards() async {
    try {
      final response = await dio.get(ApiStringConstants.myRewardsUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}

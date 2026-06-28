// lib/features/my_servings/data/datasource/my_servings_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/my_serving_model.dart';

abstract class MyServingsRemoteDataSource {
  Future<List<MyServingModel>> getMyServings();
  Future<void> updateServing(int id, MyServingModel model);
}

class MyServingsRemoteDataSourceImpl implements MyServingsRemoteDataSource {
  final Dio dio;

  MyServingsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MyServingModel>> getMyServings() async {
    try {
      final Map<String, dynamic> requestBody = {};

      final response = await dio.post(
        ApiStringConstants.getMyServingsUrl,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final List decodedJson = response.data['data'];
        return decodedJson.map((json) => MyServingModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateServing(int id, MyServingModel model) async {
    try {
      final response = await dio.put(
        "${ApiStringConstants.addPaidServiceUrl}/$id",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    }
  }
}
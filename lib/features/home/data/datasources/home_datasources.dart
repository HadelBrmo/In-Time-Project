import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../../../strategies/data/models/service_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ServiceModel>> searchServings({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> searchServings({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
  }) async {

    dynamic finalBody;
    if (servingTypeId == null && paymentUnitId == null && servingCategoryId == null && (name == null || name.isEmpty)) {
      finalBody = [];
    } else {
      finalBody = {
        if (servingTypeId != null) 'serving_type_id': servingTypeId,
        if (paymentUnitId != null) 'payment_unit_id': paymentUnitId,
        if (servingCategoryId != null) 'serving_category_id': servingCategoryId,
        if (name != null && name.trim().isNotEmpty) 'name': name,
      };
    }

    final response = await dio.post(
      '/servings/search',
      data: finalBody,
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data['data'];
      return responseData.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
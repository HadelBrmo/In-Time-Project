import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/service_item_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ServiceModel>> searchServings({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
    int? skip,
    int? take,
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
    int? skip,
    int? take,
  }) async {

    final Map<String, dynamic> requestBody = {
      'serving_type_id': servingTypeId,
      'payment_unit_id': paymentUnitId,
      'serving_category_id': servingCategoryId,
      'name': (name != null && name.trim().isNotEmpty) ? name : null,
      'skip': skip,
      'take': take,
    };

    final response = await dio.post(
      '/servings/search',
      data: requestBody,
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data['data'];
      return responseData.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}

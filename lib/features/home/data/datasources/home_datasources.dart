import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
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
  Future<List<ServiceModel>> getNearbyServings({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  });

  Future<List<ServiceModel>> getProposedServings({
    required int skip,
    required int take,
  });

  Future<void> updateServiceAvailability({
    required int serviceId,
    required Map<String, dynamic> data,
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
    try {
      final Map<String, dynamic> requestBody = {
        if (servingTypeId != null) 'serving_type_id': servingTypeId,
        if (paymentUnitId != null) 'payment_unit_id': paymentUnitId,
        if (servingCategoryId != null) 'serving_category_id': servingCategoryId,
        if (name != null && name.trim().isNotEmpty) 'name': name,
        if (skip != null) 'skip': skip,
        if (take != null) 'take': take,
      };

      final response = await dio.post(
        ApiStringConstants.searchServingsUrl,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data'];
        return responseData.map((json) => ServiceModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل البحث عن الخدمات',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر البحث عن الخدمات',
      );
    }
  }

  @override
  Future<List<ServiceModel>> getNearbyServings({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  }) async {
    try {
      final response = await dio.post(
        'servings/nearby',
        data: {
          'lat': lat,
          'lng': lng,
          'skip': skip,
          'take': take,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data'];
        return responseData.map((json) => ServiceModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل الخدمات القريبة',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل الخدمات القريبة',
      );
    }
  }

  @override
  Future<List<ServiceModel>> getProposedServings({
    required int skip,
    required int take,
  }) async {
    try {
      final response = await dio.get(
        ApiStringConstants.proposedServingsUrl,
        queryParameters: {
          'skip': skip,
          'take': take,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data'];
        return responseData.map((json) => ServiceModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل الخدمات المقترحة',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل الخدمات المقترحة',
      );
    }
  }

  @override
  Future<void> updateServiceAvailability({
    required int serviceId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.put(
        ApiStringConstants.updateAvailabilityUrl(serviceId),
        data: data,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return;
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحديث توفر الخدمة',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحديث توفر الخدمة',
      );
    }
  }
}
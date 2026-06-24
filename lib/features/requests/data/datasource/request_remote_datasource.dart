import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getMyRequests();
  Future<String> createServingRequest({
    required int servingId,
    String? message,
  });
  Future<String> deleteRequest(int requestId);
}


class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final Dio dio;

  RequestRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RequestModel>> getMyRequests() async {
    try {
      final response = await dio.get(ApiStringConstants.getMyRequestsUrl);
      if (response.statusCode == 200) {
        final List<dynamic> dataJson = response.data['data'];
        return dataJson.map((json) => RequestModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createServingRequest({
    required int servingId,
    String? message,
  }) async {
    final response = await dio.post(
      ApiStringConstants.createRequestUrl,
      data: {
        'serving_id': servingId,
        if (message != null) 'message': message,
      },
    );

    if (response.statusCode == 201) {
      return response.data['message'] ?? "Request created successfully";
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> deleteRequest(int requestId) async {
    try {
      final response = await dio.delete('${ApiStringConstants.baseUrl}${ApiStringConstants.deleteRequestUrl}$requestId');
      if (response.statusCode == 200) {
        return response.data['message'] ?? "تم حذف الطلب بنجاح";
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
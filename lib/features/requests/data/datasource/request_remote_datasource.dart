import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/request_model.dart';
import '../models/received_request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getMyRequests();
  Future<String> createServingRequest({
    required int servingId,
    String? message,
  });
  Future<String> deleteRequest(int requestId);

  // Received Requests Methods
  Future<List<ReceivedRequestGroupModel>> getReceivedRequests();
  Future<void> acceptRequest(int id);
  Future<void> rejectRequest(int id);
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

  @override
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

  @override
  Future<List<ReceivedRequestGroupModel>> getReceivedRequests() async {
    try {
      final response = await dio.get(
        '/servings/requests/received',
        queryParameters: {
          'skip': 0,
          'take': 100,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataJson = response.data['data'];
        return dataJson.map((json) => ReceivedRequestGroupModel.fromJson(json)).toList();
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

  @override
  Future<void> acceptRequest(int id) async {
    final response = await dio.put(ApiStringConstants.acceptRequestUrl(id));
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> rejectRequest(int id) async {
    final response = await dio.put(ApiStringConstants.rejectRequestUrl(id));
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}

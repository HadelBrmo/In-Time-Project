import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/received_request_model.dart';

abstract class ReceivedRequestsRemoteDataSource {
  Future<List<ReceivedRequestGroupModel>> getReceivedRequests();
  Future<void> acceptRequest(int id);
  Future<void> rejectRequest(int id);
}

class ReceivedRequestsRemoteDataSourceImpl implements ReceivedRequestsRemoteDataSource {
  final Dio dio;

  ReceivedRequestsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ReceivedRequestGroupModel>> getReceivedRequests() async {
    try {
      final response = await dio.get('${ApiStringConstants.baseUrl}/servings/requests/received');
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
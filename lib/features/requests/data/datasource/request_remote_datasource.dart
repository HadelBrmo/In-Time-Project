import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getMyRequests();
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
}
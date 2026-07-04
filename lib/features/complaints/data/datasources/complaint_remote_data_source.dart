import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/complaint_request.dart';
import '../models/complaint_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request);
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final Dio dio;

  ComplaintRemoteDataSourceImpl({required this.dio});

  @override
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request) async {
    try {
      dynamic data;
      
      if (request.attachmentPath != null && request.attachmentPath!.isNotEmpty) {
        // Handle Multipart if there's an attachment
        data = FormData.fromMap({
          'serving_id': request.servingId,
          'accused_user_id': request.accusedUserId,
          'reason': request.reason,
          'description': request.description,
          'attachment': await MultipartFile.fromFile(request.attachmentPath!),
        });
      } else {
        // Handle JSON if no attachment
        data = request.toJson();
      }

      final response = await dio.post('/complaints', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ComplaintResponse.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/complaint_request.dart';
import '../models/complaint_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request);
  Future<List<dynamic>> getMyComplaints();
  Future<void> uploadComplaintDocuments(int complaintId, List<String> filePaths);
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final Dio dio;

  ComplaintRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<dynamic>> getMyComplaints() async {
    try {
      final response = await dio.get(ApiStringConstants.myComplaintsUrl);
      if (response.statusCode == 200) {
        return response.data['data'] as List<dynamic>;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> uploadComplaintDocuments(int complaintId, List<String> filePaths) async {
    try {
      final List<MultipartFile> files = [];
      for (final path in filePaths) {
        files.add(await MultipartFile.fromFile(path));
      }

      final formData = FormData.fromMap({
        'documents[]': files,
      });

      final response = await dio.post(
        ApiStringConstants.uploadComplaintDocumentsUrl(complaintId),
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request) async {
    try {
      final Map<String, dynamic> dataMap = {
        'serving_id': request.servingId,
        'accused_user_id': request.accusedUserId,
        'reason': request.reason,
        'description': request.description,
      };

      if (request.documentPaths.isNotEmpty) {
        final List<MultipartFile> files = [];
        for (final path in request.documentPaths) {
          files.add(await MultipartFile.fromFile(path));
        }
        dataMap['documents[]'] = files;
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dio.post(
        ApiStringConstants.complaintsUrl,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ComplaintResponse.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print("DEBUG: Dio Error response: ${e.response?.data}");
      throw ServerException();
    } catch (e, stack) {
      print("DEBUG: Parsing Error in submitComplaint: $e");
      print("DEBUG: StackTrace: $stack");
      throw ServerException();
    }
  }
}

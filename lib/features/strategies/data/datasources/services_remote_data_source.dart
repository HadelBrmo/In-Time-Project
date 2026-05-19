// features/services/data/datasources/services_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_time/core/constants/app_strings.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/service_model.dart';



abstract class ServicesRemoteDataSource {
  Future<void> addService({
    required ServiceModel serviceModel,
    required XFile? image,
  });
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final Dio dio;

  ServicesRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> addService({
    required ServiceModel serviceModel,
    required XFile? image,
  }) async {
    try {
      final FormData formData = FormData.fromMap(serviceModel.toJson());

      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
          ),
        );
      }
      final response = await dio.post(
        'https://your-backend-api.com/api/servings/add-paid',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل الاتصال بالسيرفر',
        );
      }

    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'تأكد من اتصالك بالإنترنت وحاول مجدداً',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
      );
    }
  }
}
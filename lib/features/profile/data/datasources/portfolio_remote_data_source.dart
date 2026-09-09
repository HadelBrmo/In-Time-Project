import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/exceptions.dart';

abstract class PortfolioRemoteDataSource {
  Future<void> uploadImage({
    required int userId,
    required XFile image,
    required String title,
  });
  Future<void> uploadFile({
    required int userId,
    required PlatformFile file,
    required String title,
  });
  Future<void> uploadLink({
    required int userId,
    required String url,
    required String title,
  });
}

class PortfolioRemoteDataSourceImpl implements PortfolioRemoteDataSource {
  final Dio dio;

  PortfolioRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> uploadImage({
    required int userId,
    required XFile image,
    required String title,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'title': title,
        'type': 'image',
        'file': await MultipartFile.fromFile(image.path, filename: image.name),
      });

      final response = await dio.post('work-gallery/add', data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> uploadFile({
    required int userId,
    required PlatformFile file,
    required String title,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'title': title,
        'type': 'file',
        'file': await MultipartFile.fromFile(file.path!, filename: file.name),
      });

      final response = await dio.post('work-gallery/add', data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> uploadLink({
    required int userId,
    required String url,
    required String title,
  }) async {
    try {
      final response = await dio.post('work-gallery/add', data: {
        'user_id': userId,
        'title': title,
        'type': 'link',
        'link': url,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/identity_status_model.dart';

abstract class VerificationRemoteDataSource {
  Future<String> verifyIdentity();
  Future<IdentityStatusModel> getIdentityStatus();
}

class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final Dio dio;

  VerificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> verifyIdentity() async {
    try {
      final response = await dio.post(
        ApiStringConstants.verifyIdentityUrl,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true && response.data['verification_url'] != null) {
          return response.data['verification_url'];
        }
        throw ServerExceptionWithDetails(message: response.data['message'] ?? 'فشل إنشاء جلسة التحقق');
      } else {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: response.data['message'] ?? 'فشل إرسال طلب التحقق',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تأكد من الاتصال بالشبكة وأعد المحاولة',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء إرسال طلب التحقق',
      );
    }
  }

  @override
  Future<IdentityStatusModel> getIdentityStatus() async {
    try {
      final response = await dio.get(
        ApiStringConstants.identityStatusUrl,
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true && response.data['data'] != null) {
          return IdentityStatusModel.fromJson(response.data['data']);
        }
        throw ServerExceptionWithDetails(message: response.data['message'] ?? 'فشل جلب حالة التحقق');
      } else {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: response.data['message'] ?? 'فشل جلب حالة التحقق',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تأكد من الاتصال بالشبكة وأعد المحاولة',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء جلب حالة التحقق',
      );
    }
  }
}

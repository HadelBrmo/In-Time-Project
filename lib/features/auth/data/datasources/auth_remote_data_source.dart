// features/auth/data/datasources/auth_remote_data_source.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/login_auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginAuthModel> login({required String email,required String password,});
  Future<Response> sendOtp({required String email});
  Future<Unit> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String otp,
    required String gender,
    required String currentJob,
    required String address,
    required String birthDate,
    File? profilePicture,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginAuthModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiStringConstants.loginUrl,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginAuthModel.fromJson(response.data);
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل تسجيل الدخول',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'تأكد من الاتصال بالشبكة وأعد المحاولة',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء تسجيل الدخول',
      );
    }
  }

  @override
  Future<Response> sendOtp({required String email}) async {
    return await dio.post(
      ApiStringConstants.sendOtpUrl,
      data: {"email": email},
    );
  }

  @override
  Future<Unit> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String otp,
    required String gender,
    required String currentJob,
    required String address,
    required String birthDate,
    File? profilePicture,
  }) async {
    try {
      final formDataMap = {
        "full_name": fullName,
        "email": email,
        "password": password,
        "phone": phone,
        "otp": otp,
        "gender": gender,
        "current_job": currentJob,
        "address": address,
        "birth_date": birthDate,
      };
      final formData = FormData.fromMap(formDataMap);

      if (profilePicture != null) {
        formData.files.add(MapEntry(
          "profile_picture",
          await MultipartFile.fromFile(
            profilePicture.path,
            filename: profilePicture.path.split('/').last,
          ),
        ));
      }

      final response = await dio.post(
        ApiStringConstants.registerCustomerUrl,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return unit;
      } else {
        throw ServerExceptionWithDetails(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'فشل عملية التسجيل',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.response?.statusCode,
        message: e.response?.data['message'] ?? 'تأكد من الاتصال بالشبكة وأعد المحاولة',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء التسجيل',
      );
    }
  }
}

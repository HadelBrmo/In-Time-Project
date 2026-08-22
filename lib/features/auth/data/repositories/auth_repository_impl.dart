// features/auth/data/repositories/auth_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/login_auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, LoginAuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginModel = await remoteDataSource.login(email: email, password: password);

      await _saveAuthData(loginModel);

      return Right(loginModel);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LoginAuthEntity>> refreshToken({required String refreshToken}) async {
    try {
      final loginModel = await remoteDataSource.refreshToken(refreshToken: refreshToken);

      await _saveAuthData(loginModel);

      return Right(loginModel);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<void> _saveAuthData(LoginAuthEntity authData) async {
    try {
      if (authData.userId != 0) {
        await sharedPreferences.setInt("user_id", authData.userId);
      }
      await sharedPreferences.setString("full_name", authData.fullName);
      await sharedPreferences.setString("email", authData.email);
      await sharedPreferences.setBool("is_identity_verified", authData.isIdentityVerified);
      if (authData.profilePicture != null) {
        await sharedPreferences.setString("profile_picture", authData.profilePicture!);
      }
      if (authData.token.isNotEmpty) {
        await localDataSource.saveToken(authData.token);
        await sharedPreferences.setString("token", authData.token);
      }
      if (authData.refreshToken != null) {
        await sharedPreferences.setString("refresh_token", authData.refreshToken!);
      }
      if (authData.expiresIn != null) {
        await sharedPreferences.setInt("expires_in", authData.expiresIn!);
        final expiryTime = DateTime.now().add(Duration(seconds: authData.expiresIn!));
        await sharedPreferences.setString("expiry_date", expiryTime.toIso8601String());
      }
    } catch (_) {
      // Best effort only: local persistence should not fail a successful login/refresh.
    }
  }

  @override
  Future<void> sendOtp({required String email}) async {
    try {
      final response = await remoteDataSource.sendOtp(email: email);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
      throw ServerExceptionWithDetails(
        statusCode: response.statusCode,
        message: 'فشل إرسال رمز التحقق',
      );
    } on ServerExceptionWithDetails catch (e) {
      throw ServerExceptionWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء إرسال رمز التحقق',
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
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
      await remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        otp: otp,
        gender: gender,
        currentJob: currentJob,
        address: address,
        birthDate: birthDate,
        profilePicture: profilePicture,
      );
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyIdentity({
    required String documentType,
    required File documentImage,
  }) async {
    try {
      await remoteDataSource.verifyIdentity(
        documentType: documentType,
        documentImage: documentImage,
      );
      await sharedPreferences.setBool("is_identity_verified", true);
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

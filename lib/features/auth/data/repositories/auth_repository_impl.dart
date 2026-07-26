// features/auth/data/repositories/auth_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/login_auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LoginAuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginModel = await remoteDataSource.login(email: email, password: password);

      await localDataSource.saveAuthData(loginModel);

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

      await localDataSource.saveAuthData(loginModel);

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
  Future<void> sendOtp({required String email}) async {
    try {
      final response = await remoteDataSource.sendOtp(email: email);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception("فشل إرسال رمز التحقق");
      }
    } catch (e) {
      throw Exception("حدث خطأ في الاتصال: $e");
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
}

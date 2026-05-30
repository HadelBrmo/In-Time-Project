// features/auth/domain/repositories/auth_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/login_auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginAuthEntity>> login({required String email, required String password,});
  Future<void> sendOtp({required String email});
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
  });
}


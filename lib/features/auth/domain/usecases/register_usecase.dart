import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({
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
    return await repository.register(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      otp: otp,
      gender: gender == "ذكر" ? "male" : "female",
      currentJob: currentJob,
      address: address,
      birthDate: birthDate,
      profilePicture: profilePicture,
    );
  }
}

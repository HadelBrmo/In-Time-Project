import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyIdentityUseCase {
  final AuthRepository repository;

  VerifyIdentityUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.verifyIdentity();
  }
}

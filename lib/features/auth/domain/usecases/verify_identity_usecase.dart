import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyIdentityUseCase {
  final AuthRepository repository;

  VerifyIdentityUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String documentType,
    required File documentImage,
  }) async {
    return await repository.verifyIdentity(
      documentType: documentType,
      documentImage: documentImage,
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/verification_repository.dart';

class VerifyIdentityUseCase {
  final VerificationRepository repository;

  VerifyIdentityUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.verifyIdentity();
  }
}

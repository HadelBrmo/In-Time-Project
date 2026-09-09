import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/identity_status_entity.dart';
import '../repositories/verification_repository.dart';

class GetIdentityStatusUseCase {
  final VerificationRepository repository;

  GetIdentityStatusUseCase(this.repository);

  Future<Either<Failure, IdentityStatusEntity>> call() async {
    return await repository.getIdentityStatus();
  }
}

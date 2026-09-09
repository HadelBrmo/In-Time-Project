import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/identity_status_entity.dart';

abstract class VerificationRepository {
  Future<Either<Failure, String>> verifyIdentity();
  Future<Either<Failure, IdentityStatusEntity>> getIdentityStatus();
}

// features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/login_auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginAuthEntity>> login({required String email, required String password,});
  Future<void> sendOtp({required String email});
}


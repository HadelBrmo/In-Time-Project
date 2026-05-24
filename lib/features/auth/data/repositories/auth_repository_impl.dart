// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/login_auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoginAuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginModel = await remoteDataSource.login(email: email, password: password);
      return Right(loginModel);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure() as Failure);
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
}

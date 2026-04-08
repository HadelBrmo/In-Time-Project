import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';
import '../datasources/auth_local_ds.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final result = await remoteDataSource.register(userModel);
    return result.toEntity();
  }
}
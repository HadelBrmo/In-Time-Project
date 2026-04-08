abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Implement API call
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(UserModel user) async {
    // Implement API call
    throw UnimplementedError();
  }
}
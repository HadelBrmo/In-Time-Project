abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(UserModel user) async {
    // Implement caching
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Implement retrieval
    return null;
  }
}
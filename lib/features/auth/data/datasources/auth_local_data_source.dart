import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'CACHED_AUTH_TOKEN', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'CACHED_AUTH_TOKEN');
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(key: 'CACHED_AUTH_TOKEN');
  }
}
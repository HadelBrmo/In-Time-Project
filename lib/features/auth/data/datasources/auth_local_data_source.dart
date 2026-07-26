import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/login_auth_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveAuthData(LoginAuthEntity authData);
  Future<void> clearAuthData();
  Future<int?> getUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  static const String _tokenKey = 'CACHED_AUTH_TOKEN';
  static const String _userIdKey = 'user_id';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'email';
  static const String _profilePictureKey = 'profile_picture';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresInKey = 'expires_in';
  static const String _expiryDateKey = 'expiry_date';

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
    await sharedPreferences.setString("token", token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(key: _tokenKey);
    await sharedPreferences.remove("token");
  }

  @override
  Future<void> saveAuthData(LoginAuthEntity authData) async {
    if (authData.userId != 0) {
      await sharedPreferences.setInt(_userIdKey, authData.userId);
    }
    await sharedPreferences.setString(_fullNameKey, authData.fullName);
    await sharedPreferences.setString(_emailKey, authData.email);
    
    if (authData.profilePicture != null) {
      await sharedPreferences.setString(_profilePictureKey, authData.profilePicture!);
    }
    
    if (authData.token.isNotEmpty) {
      await saveToken(authData.token);
    }
    
    if (authData.refreshToken != null) {
      await sharedPreferences.setString(_refreshTokenKey, authData.refreshToken!);
    }
    
    if (authData.expiresIn != null) {
      await sharedPreferences.setInt(_expiresInKey, authData.expiresIn!);
      final expiryTime = DateTime.now().add(Duration(seconds: authData.expiresIn!));
      await sharedPreferences.setString(_expiryDateKey, expiryTime.toIso8601String());
    }
  }

  @override
  Future<void> clearAuthData() async {
    await clearToken();
    await sharedPreferences.remove(_userIdKey);
    await sharedPreferences.remove(_fullNameKey);
    await sharedPreferences.remove(_emailKey);
    await sharedPreferences.remove(_profilePictureKey);
    await sharedPreferences.remove(_refreshTokenKey);
    await sharedPreferences.remove(_expiresInKey);
    await sharedPreferences.remove(_expiryDateKey);
  }

  @override
  Future<int?> getUserId() async {
    return sharedPreferences.getInt(_userIdKey);
  }
}

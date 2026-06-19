import '../../domain/entities/login_auth_entity.dart';

class LoginAuthModel extends LoginAuthEntity {
  const LoginAuthModel({
    required super.token,
    super.refreshToken,
    super.expiresIn,
  });

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) {
    return LoginAuthModel(
      token: json['token'] ?? json['access_token'] ?? '',
      refreshToken: json['refresh_token']?.toString(),
      expiresIn: json['expires_in'] is int
          ? json['expires_in']
          : int.tryParse(json['expires_in']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}
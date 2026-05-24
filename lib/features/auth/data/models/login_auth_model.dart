import '../../domain/entities/login_auth_entity.dart';

class LoginAuthModel extends LoginAuthEntity {
  const LoginAuthModel({required super.token});

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) {
    return LoginAuthModel(
      token: json['token'] ?? json['access_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
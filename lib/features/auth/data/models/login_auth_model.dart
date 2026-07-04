import '../../domain/entities/login_auth_entity.dart';

class LoginAuthModel extends LoginAuthEntity {
  const LoginAuthModel({
    required super.userId,
    required super.fullName,
    required super.email,
    super.profilePicture,
    required super.token,
    super.refreshToken,
    super.expiresIn,
  });

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];
    
    return LoginAuthModel(
      userId: userData != null ? (userData['id'] ?? 0) : 0,
      fullName: userData != null ? (userData['full_name'] ?? '') : '',
      email: userData != null ? (userData['email'] ?? '') : '',
      profilePicture: userData != null ? userData['profile_picture']?.toString() : null,
      token: json['token'] ?? json['access_token'] ?? '',
      refreshToken: json['refresh_token']?.toString(),
      expiresIn: json['expires_in'] is int
          ? json['expires_in']
          : int.tryParse(json['expires_in']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'profile_picture': profilePicture,
      'token': token,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}

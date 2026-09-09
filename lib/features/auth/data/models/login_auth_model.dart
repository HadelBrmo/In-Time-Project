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
    super.isIdentityVerified,
  });

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];
    
    return LoginAuthModel(
      userId: userData != null ? (userData['id'] ?? 0) : 0,
      fullName: userData != null ? (userData['full_name'] ?? '') : '',
      email: userData != null ? (userData['email'] ?? '') : '',
      profilePicture: userData != null ? userData['profile_picture']?.toString() : null,
      isIdentityVerified: userData != null ? (userData['is_identity_verified'] is bool ? userData['is_identity_verified'] : (userData['is_identity_verified'] == 1 || userData['is_identity_verified'] == true)) : false,
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
      'is_identity_verified': isIdentityVerified,
      'token': token,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}

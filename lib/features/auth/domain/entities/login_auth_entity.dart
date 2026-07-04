import 'package:equatable/equatable.dart';

class LoginAuthEntity extends Equatable {
  final int userId;
  final String fullName;
  final String email;
  final String? profilePicture;
  final String token;
  final String? refreshToken;
  final int? expiresIn;

  const LoginAuthEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    this.profilePicture,
    required this.token,
    this.refreshToken,
    this.expiresIn,
  });

  @override
  List<Object?> get props => [userId, fullName, email, profilePicture, token, refreshToken, expiresIn];
}

// features/auth/domain/entities/login_auth_entity.dart
import 'package:equatable/equatable.dart';

class LoginAuthEntity extends Equatable {
  final String token;
  final String? refreshToken;
  final int? expiresIn;

  const LoginAuthEntity({
    required this.token,
    this.refreshToken,
    this.expiresIn,
  });

  @override
  List<Object?> get props => [token, refreshToken, expiresIn];
}
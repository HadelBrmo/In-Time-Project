// features/auth/domain/entities/login_auth_entity.dart
import 'package:equatable/equatable.dart';

class LoginAuthEntity extends Equatable {
  final String token;

  const LoginAuthEntity({required this.token});

  @override
  List<Object?> get props => [token];
}


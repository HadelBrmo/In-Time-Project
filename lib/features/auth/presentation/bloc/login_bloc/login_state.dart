// features/auth/presentation/bloc/login_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/login_auth_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final LoginAuthEntity authEntity;
  const LoginSuccess({required this.authEntity});

  @override
  List<Object?> get props => [authEntity];
}
class LoginError extends LoginState {
  final String errorMessage;
  final int? statusCode;

  const LoginError({required this.errorMessage, this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}
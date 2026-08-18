import 'package:equatable/equatable.dart';

sealed class IdentityVerificationState extends Equatable {
  const IdentityVerificationState();

  @override
  List<Object?> get props => [];
}

final class IdentityVerificationInitial extends IdentityVerificationState {}

final class IdentityVerificationLoading extends IdentityVerificationState {}

final class IdentityVerificationSuccess extends IdentityVerificationState {}

final class IdentityVerificationFailure extends IdentityVerificationState {
  final String message;

  const IdentityVerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

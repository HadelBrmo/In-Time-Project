import 'package:equatable/equatable.dart';
import '../../../domain/entities/identity_status_entity.dart';

sealed class IdentityVerificationState extends Equatable {
  const IdentityVerificationState();

  @override
  List<Object?> get props => [];
}

final class IdentityVerificationInitial extends IdentityVerificationState {}

final class IdentityVerificationLoading extends IdentityVerificationState {}

final class IdentityVerificationSessionCreated extends IdentityVerificationState {
  final String verificationUrl;

  const IdentityVerificationSessionCreated(this.verificationUrl);

  @override
  List<Object?> get props => [verificationUrl];
}

final class IdentityStatusLoaded extends IdentityVerificationState {
  final IdentityStatusEntity identityStatus;

  const IdentityStatusLoaded(this.identityStatus);

  @override
  List<Object?> get props => [identityStatus];
}

final class IdentityVerificationFailure extends IdentityVerificationState {
  final String message;

  const IdentityVerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

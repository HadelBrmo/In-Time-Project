import 'package:equatable/equatable.dart';

class IdentityStatusEntity extends Equatable {
  final String status;
  final String? sessionId;
  final DateTime? verifiedAt;
  final bool isIdentityVerified;

  const IdentityStatusEntity({
    required this.status,
    this.sessionId,
    this.verifiedAt,
    required this.isIdentityVerified,
  });

  @override
  List<Object?> get props => [status, sessionId, verifiedAt, isIdentityVerified];
}

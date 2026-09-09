import '../../domain/entities/identity_status_entity.dart';

class IdentityStatusModel extends IdentityStatusEntity {
  const IdentityStatusModel({
    required super.status,
    super.sessionId,
    super.verifiedAt,
    required super.isIdentityVerified,
  });

  factory IdentityStatusModel.fromJson(Map<String, dynamic> json) {
    return IdentityStatusModel(
      status: json['status'] ?? 'none',
      sessionId: json['session_id'],
      verifiedAt: json['verified_at'] != null ? DateTime.parse(json['verified_at']) : null,
      isIdentityVerified: json['is_identity_verified'] ?? false,
    );
  }
}

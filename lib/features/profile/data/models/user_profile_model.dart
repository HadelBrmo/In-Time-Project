import '../../domain/entities/profile_entity.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.currentJob,
    super.address,
    required super.gender,
    super.birthDate,
    super.profilePicture,
    required super.role,
    required super.isActive,
    required super.isVerified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      currentJob: json['current_job'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String? ?? 'not specified',
      birthDate: json['birth_date'] as String?,
      profilePicture: json['profile_picture'] as String?,
      role: json['role'] as String? ?? 'user',
      isActive: json['is_active'] as bool? ?? false,
      isVerified: json['is_identity_verified'] is bool
          ? json['is_identity_verified']
          : (json['is_identity_verified'] == 1 || json['is_identity_verified'] == true),
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

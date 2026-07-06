import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? currentJob;
  final String? address;
  final String gender;
  final String? birthDate;
  final String? profilePicture;
  final String role;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.currentJob,
    this.address,
    required this.gender,
    this.birthDate,
    this.profilePicture,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        currentJob,
        address,
        gender,
        birthDate,
        profilePicture,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}
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

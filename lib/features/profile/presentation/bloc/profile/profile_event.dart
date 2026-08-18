abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final int userId;
  FetchProfile(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final int userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? currentJob;
  final String? address;
  final String? gender;
  final String? birthDate;
  final String? profilePicturePath;

  UpdateProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.currentJob,
    this.address,
    this.gender,
    this.birthDate,
    this.profilePicturePath,
  });
}

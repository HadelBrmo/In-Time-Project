//class PortfolioPage {}

import 'package:dio/dio.dart';

class UserProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? currentJob;
  final String? address;
  final String? gender;
  final String? birthDate;
  final String? profilePicture;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.currentJob,
    this.address,
    this.gender,
    this.birthDate,
    this.profilePicture,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      phone: json["phone_number"],
      currentJob: json["current_job"],
      address: json["address"],
      gender: json["gender"],
      birthDate: json["birth_date"],
      profilePicture: json["profile_picture"],
    );
  }
}


//
class ProfileRemoteDataSource {

  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<UserProfileModel> getProfile() async {

    final response = await dio.get(
      "http://ali.ba-tech.tech/api/users/3",
    );

    return UserProfileModel.fromJson(response.data["data"]);
  }
}

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpState extends Equatable {
  final File? profileImage;
  final LatLng? selectedLocation;
  final String fullName;
  final String currentJob;
  final String address;
  final String gender;
  final String birthDate;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String otp;

  final SignUpStatus status;
  final String errorMessage;

  const SignUpState({
    this.profileImage,
    this.selectedLocation,
    this.fullName = "",
    this.currentJob = "",
    this.address = "",
    this.gender = "ذكر",
    this.birthDate = "",
    this.email = "",
    this.phone = "",
    this.password = "",
    this.confirmPassword = "",
    this.otp = "",
    this.status = SignUpStatus.initial,
    this.errorMessage = "",
  });

  SignUpState copyWith({
    File? profileImage,
    LatLng? selectedLocation,
    String? fullName,
    String? currentJob,
    String? address,
    String? gender,
    String? birthDate,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? otp,
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      profileImage: profileImage ?? this.profileImage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      fullName: fullName ?? this.fullName,
      currentJob: currentJob ?? this.currentJob,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    profileImage,
    selectedLocation,
    fullName,
    currentJob,
    address,
    gender,
    birthDate,
    email,
    phone,
    password,
    confirmPassword,
    otp,
    status,
    errorMessage,
  ];
}

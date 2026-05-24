import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpState extends Equatable {
  final File? profileImage;
  final LatLng? selectedLocation;
  final String address;
  final String gender;
  final String birthDate;

  final SignUpStatus status;
  final String errorMessage;

  const SignUpState({
    this.profileImage,
    this.selectedLocation,
    this.address = "",
    this.gender = "ذكر",
    this.birthDate = "",
    this.status = SignUpStatus.initial,
    this.errorMessage = "",
  });

  SignUpState copyWith({
    File? profileImage,
    LatLng? selectedLocation,
    String? address,
    String? gender,
    String? birthDate,
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      profileImage: profileImage ?? this.profileImage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    profileImage,
    selectedLocation,
    address,
    gender,
    birthDate,
    status,
    errorMessage,
  ];
}
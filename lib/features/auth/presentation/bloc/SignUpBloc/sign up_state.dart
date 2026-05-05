import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignUpState extends Equatable {
  final File? profileImage;
  final LatLng? selectedLocation;
  final String address;
  final String gender;

  const SignUpState({this.profileImage, this.selectedLocation, this.address = "", this.gender = "ذكر"});

  SignUpState copyWith({File? profileImage, LatLng? selectedLocation, String? address, String? gender}) {
    return SignUpState(
      profileImage: profileImage ?? this.profileImage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      address: address ?? this.address,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [profileImage, selectedLocation, address, gender];
}
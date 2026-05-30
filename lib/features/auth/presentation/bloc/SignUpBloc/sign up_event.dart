import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}

class PickProfileImageEvent extends SignUpEvent {}

class UpdateLocationEvent extends SignUpEvent {
  final LatLng position;
  final String address;
  const UpdateLocationEvent(this.position, this.address);

  @override
  List<Object?> get props => [position, address];
}

class UpdateBirthDateEvent extends SignUpEvent {
  final String birthDate;
  const UpdateBirthDateEvent(this.birthDate);

  @override
  List<Object?> get props => [birthDate];
}

class UpdateGenderEvent extends SignUpEvent {
  final String gender;
  const UpdateGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

class UpdateSignUpFieldsEvent extends SignUpEvent {
  final String? fullName;
  final String? currentJob;
  final String? address;
  final String? email;
  final String? phone;
  final String? password;
  final String? confirmPassword;
  final String? otp;

  const UpdateSignUpFieldsEvent({
    this.fullName,
    this.currentJob,
    this.address,
    this.email,
    this.phone,
    this.password,
    this.confirmPassword,
    this.otp,
  });

  @override
  List<Object?> get props => [fullName, currentJob, address, email, phone, password, confirmPassword, otp];
}

class SignUpSubmittedEvent extends SignUpEvent {
  const SignUpSubmittedEvent();
}

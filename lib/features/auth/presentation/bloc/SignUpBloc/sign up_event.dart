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

class SubmitSignUpEvent extends SignUpEvent {}
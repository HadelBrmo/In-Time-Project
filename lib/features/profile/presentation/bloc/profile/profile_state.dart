// lib/features/profile/presentation/bloc/profile_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية
class ProfileInitial extends ProfileState {}

// جارٍ التحميل (GET)
class ProfileLoading extends ProfileState {}

// تم التحميل بنجاح (GET)
class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  const ProfileLoaded(this.userProfile);
  @override
  List<Object?> get props => [userProfile];
}

// جارٍ التحديث (POST)
class ProfileUpdating extends ProfileState {}

// تم التحديث بنجاح (POST)
class ProfileUpdateSuccess extends ProfileState {
  final UserProfile userProfile;
  final String message;
  const ProfileUpdateSuccess(this.userProfile, this.message);
  @override
  List<Object?> get props => [userProfile, message];
}

// حالة الخطأ (لكل من GET و POST)
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getUserProfileUseCase(event.userId);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileUpdating());
      try {
        final updatedProfile = await updateProfileUseCase({
          'id': event.userId,
          'full_name': event.fullName,
          'email': event.email,
          'phone_number': event.phoneNumber,
          'current_job': event.currentJob,
          'address': event.address,
          'gender': event.gender,
          'birth_date': event.birthDate,
          'profile_picture_path': event.profilePicturePath,
        });
        emit(ProfileUpdateSuccess(updatedProfile, 'تم تحديث الملف الشخصي بنجاح ✅'));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}

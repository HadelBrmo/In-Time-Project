import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/features/profile/presentation/bloc/profile/profile_event.dart';
import 'profile_state.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../../../../../core/network/api_result.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      
      final result = await getUserProfileUseCase(event.userId);
      
      switch (result) {
        case Success(data: final profile):
          emit(ProfileLoaded(profile));
        case FailureResult(failure: final failure):
          emit(ProfileError(failure.message));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileUpdating());
      
      final result = await updateProfileUseCase({
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

      switch (result) {
        case Success(data: final updatedProfile):
          emit(ProfileUpdateSuccess(updatedProfile, 'تم تحديث الملف الشخصي بنجاح ✅'));
        case FailureResult(failure: final failure):
          emit(ProfileError(failure.message));
      }
    });
  }
}

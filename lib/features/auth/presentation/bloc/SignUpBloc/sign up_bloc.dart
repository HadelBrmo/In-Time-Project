import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'sign up_event.dart';
import 'sign up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ImagePicker _picker = ImagePicker();
  final RegisterUseCase registerUseCase;

  SignUpBloc({required this.registerUseCase}) : super(const SignUpState()) {

    on<PickProfileImageEvent>((event, emit) async {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(state.copyWith(profileImage: File(image.path)));
      }
    });

    on<UpdateLocationEvent>((event, emit) {
      emit(state.copyWith(selectedLocation: event.position, address: event.address));
    });

    on<UpdateGenderEvent>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    on<UpdateBirthDateEvent>((event, emit) {
      emit(state.copyWith(birthDate: event.birthDate));
    });

    on<UpdateSignUpFieldsEvent>((event, emit) {
      emit(state.copyWith(
        fullName: event.fullName,
        currentJob: event.currentJob,
        address: event.address,
        email: event.email,
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
        otp: event.otp,
      ));
    });

    on<SignUpSubmittedEvent>((event, emit) async {
      emit(state.copyWith(status: SignUpStatus.loading));
      
      final result = await registerUseCase.call(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
        phone: state.phone,
        otp: state.otp,
        gender: state.gender,
        currentJob: state.currentJob,
        address: state.address,
        birthDate: state.birthDate,
        profilePicture: state.profileImage,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: SignUpStatus.error,
          errorMessage: failure.message,
        )),
        (_) => emit(state.copyWith(status: SignUpStatus.success)),
      );
    });
  }
}

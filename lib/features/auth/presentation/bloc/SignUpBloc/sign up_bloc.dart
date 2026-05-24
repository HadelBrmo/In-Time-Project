import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'sign up_event.dart';
import 'sign up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ImagePicker _picker = ImagePicker();

  SignUpBloc() : super( SignUpState()) {

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
  }
}
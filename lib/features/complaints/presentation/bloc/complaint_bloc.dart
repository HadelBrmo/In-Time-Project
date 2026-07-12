import 'package:flutter_bloc/flutter_bloc.dart';
import 'complaint_event.dart';
import 'complaint_state.dart';
import '../../domain/usecases/submit_complaint_usecase.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final SubmitComplaintUseCase submitComplaintUseCase;

  ComplaintBloc({required this.submitComplaintUseCase}) : super(ComplaintInitial()) {
    on<SubmitComplaintEvent>((event, emit) async {
      emit(ComplaintSubmitting());
      try {
        final response = await submitComplaintUseCase(event.request);
        emit(ComplaintSuccess(response));
      } catch (e) {
        emit(ComplaintError(e.toString()));
      }
    });
  }
}

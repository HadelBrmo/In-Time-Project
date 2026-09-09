import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/send_otp_use_case.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final SendOtpUseCase sendOtpUseCase;

  OtpBloc({required this.sendOtpUseCase}) : super(const OtpState()) {

    on<SendOtpRequestedEvent>((event, emit) async {
      emit(state.copyWith(status: OtpStatus.loading));
      try {
        await sendOtpUseCase(email: event.email);

        emit(state.copyWith(
          status: OtpStatus.success,
          isOtpSent: true,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: OtpStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
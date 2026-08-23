import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_identity_status_usecase.dart';
import '../../../domain/usecases/verify_identity_usecase.dart';
import 'identity_verification_state.dart';

class IdentityVerificationCubit extends Cubit<IdentityVerificationState> {
  final VerifyIdentityUseCase verifyIdentityUseCase;
  final GetIdentityStatusUseCase getIdentityStatusUseCase;
  Timer? _pollingTimer;

  IdentityVerificationCubit(this.verifyIdentityUseCase, this.getIdentityStatusUseCase) : super(IdentityVerificationInitial());

  Future<void> startVerification() async {
    emit(IdentityVerificationLoading());

    final result = await verifyIdentityUseCase();

    result.fold(
      (failure) => emit(IdentityVerificationFailure(failure.message)),
      (url) => emit(IdentityVerificationSessionCreated(url)),
    );
  }

  Future<void> getStatus() async {
    final result = await getIdentityStatusUseCase();

    result.fold(
      (failure) => emit(IdentityVerificationFailure(failure.message)),
      (status) {
        emit(IdentityStatusLoaded(status));
        if (status.status == 'pending' || status.status == 'resubmission_requested') {
          _startPolling();
        } else {
          _stopPolling();
        }
      },
    );
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      getStatus();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/verify_identity_usecase.dart';
import 'identity_verification_state.dart';

class IdentityVerificationCubit extends Cubit<IdentityVerificationState> {
  final VerifyIdentityUseCase verifyIdentityUseCase;

  IdentityVerificationCubit(this.verifyIdentityUseCase) : super(IdentityVerificationInitial());

  Future<void> verifyIdentity({
    required String documentType,
    required File documentImage,
  }) async {
    emit(IdentityVerificationLoading());

    final result = await verifyIdentityUseCase(
      documentType: documentType,
      documentImage: documentImage,
    );

    result.fold(
      (failure) => emit(IdentityVerificationFailure(failure.message)),
      (_) => emit(IdentityVerificationSuccess()),
    );
  }
}

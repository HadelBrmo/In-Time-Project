// features/auth/presentation/bloc/login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmittedEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    final result = await loginUseCase.call(
      email: event.email,
      password: event.password,
    );

    result.fold(
          (failure) {
        if (failure is ServerFailureWithDetails) {
          emit(LoginError(errorMessage: failure.message, statusCode: failure.statusCode));
        } else {
          emit(const LoginError(errorMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"));
        }
      },
          (authEntity) => emit(LoginSuccess(authEntity: authEntity)),
    );
  }
}
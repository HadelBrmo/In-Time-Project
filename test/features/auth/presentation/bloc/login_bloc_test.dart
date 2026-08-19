import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_time/core/error/failures.dart';
import 'package:in_time/features/auth/domain/entities/login_auth_entity.dart';
import 'package:in_time/features/auth/domain/usecases/login_usecase.dart';
import 'package:in_time/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:in_time/features/auth/presentation/bloc/login_bloc/login_event.dart';
import 'package:in_time/features/auth/presentation/bloc/login_bloc/login_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tLoginAuthEntity = LoginAuthEntity(
    userId: 1,
    fullName: 'Test User',
    email: 'test@example.com',
    token: 'token123',
  );

  test('initial state should be LoginInitial', () {
    expect(loginBloc.state, equals(LoginInitial()));
  });

  group('LoginSubmittedEvent', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        when(() => mockLoginUseCase.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Right(tLoginAuthEntity));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmittedEvent(email: tEmail, password: tPassword)),
      expect: () => [
        LoginLoading(),
        const LoginSuccess(authEntity: tLoginAuthEntity),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(email: tEmail, password: tPassword)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when login fails with ServerFailureWithDetails',
      build: () {
        when(() => mockLoginUseCase.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(ServerFailureWithDetails(message: 'Invalid credentials', statusCode: 401)));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmittedEvent(email: tEmail, password: tPassword)),
      expect: () => [
        LoginLoading(),
        const LoginError(errorMessage: 'Invalid credentials', statusCode: 401),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] with default message when login fails with other failures',
      build: () {
        when(() => mockLoginUseCase.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(ServerFailure()));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmittedEvent(email: tEmail, password: tPassword)),
      expect: () => [
        LoginLoading(),
        const LoginError(errorMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً"),
      ],
    );
  });
}

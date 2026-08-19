import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_time/features/auth/domain/entities/login_auth_entity.dart';
import 'package:in_time/features/auth/domain/repositories/auth_repository.dart';
import 'package:in_time/features/auth/domain/usecases/login_usecase.dart';
import 'package:in_time/core/error/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tLoginAuthEntity = LoginAuthEntity(
    userId: 1,
    fullName: 'Test User',
    email: 'test@example.com',
    token: 'token123',
  );

  test(
    'should call login on the repository with correct parameters',
    () async {
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tLoginAuthEntity));

      // act
      await useCase(email: tEmail, password: tPassword);

      // assert
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return LoginAuthEntity when login is successful',
    () async {
      // arrange
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tLoginAuthEntity));

      // act
      final result = await useCase(email: tEmail, password: tPassword);

      // assert
      expect(result, const Right(tLoginAuthEntity));
    },
  );

  test(
    'should return Failure when login is unsuccessful',
    () async {
      // arrange
      final tFailure = ServerFailure('Invalid credentials');
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await useCase(email: tEmail, password: tPassword);

      // assert
      expect(result, Left(tFailure));
    },
  );
}

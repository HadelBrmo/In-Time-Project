import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_time/features/auth/domain/entities/identity_status_entity.dart';
import 'package:in_time/features/auth/domain/repositories/auth_repository.dart';
import 'package:in_time/features/auth/domain/usecases/get_identity_status_usecase.dart';
import 'package:in_time/core/error/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetIdentityStatusUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetIdentityStatusUseCase(mockAuthRepository);
  });

  const tStatus = IdentityStatusEntity(
    status: 'pending',
    isIdentityVerified: false,
  );

  test(
    'should get identity status from the repository',
    () async {
      // arrange
      when(() => mockAuthRepository.getIdentityStatus())
          .thenAnswer((_) async => const Right(tStatus));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tStatus));
      verify(() => mockAuthRepository.getIdentityStatus()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return failure when repository returns failure',
    () async {
      // arrange
      final tFailure = ServerFailure('Status check failed');
      when(() => mockAuthRepository.getIdentityStatus())
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(tFailure));
    },
  );
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class VerifyIdentityUseCase implements UseCase<bool, VerifyIdentityParams> {
  // Implement
  @override
  Future<Either<Failure, bool>> call(VerifyIdentityParams params) async {
    throw UnimplementedError();
  }
}

class VerifyIdentityParams {
  final String imagePath;

  VerifyIdentityParams({required this.imagePath});
}
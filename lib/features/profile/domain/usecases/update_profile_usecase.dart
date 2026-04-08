import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';

class UpdateProfileUseCase implements UseCase<ProfileEntity, UpdateParams> {
  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateParams params) async {
    throw UnimplementedError();
  }
}

class UpdateParams {
  final ProfileEntity profile;

  UpdateParams({required this.profile});
}
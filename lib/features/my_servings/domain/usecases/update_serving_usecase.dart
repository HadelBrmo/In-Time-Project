// lib/features/my_servings/domain/usecase/update_serving_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/my_servings_repository.dart';

class UpdateServingUseCase {
  final MyServingsRepository repository;
  UpdateServingUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  }) async {
    return await repository.updateServing(
      id: id,
      title: title,
      description: description,
      costAmount: costAmount,
      meetingType: meetingType,
    );
  }
}
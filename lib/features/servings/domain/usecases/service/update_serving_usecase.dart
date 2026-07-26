import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repository/services_repository.dart';

class UpdateServingUseCase {
  final ServicesRepository repository;
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

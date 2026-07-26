import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../repository/services_repository.dart';

class ToggleServingStatusUseCase {
  final ServicesRepository repository;
  ToggleServingStatusUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id, bool isActive) async {
    return await repository.toggleServingStatus(id, isActive);
  }
}

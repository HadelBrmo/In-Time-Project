import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/request_repository.dart';

class RejectRequestUseCase {
  final RequestRepository repository;

  RejectRequestUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.rejectRequest(id);
  }
}

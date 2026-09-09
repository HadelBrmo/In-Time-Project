import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/request_repository.dart';

class AcceptRequestUseCase {
  final RequestRepository repository;

  AcceptRequestUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.acceptRequest(id);
  }
}

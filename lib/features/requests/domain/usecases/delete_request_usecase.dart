import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/request_repository.dart';

class DeleteRequestUseCase {
  final RequestRepository repository;

  DeleteRequestUseCase(this.repository);

  Future<Either<Failure, String>> call(int requestId) async {
    return await repository.deleteRequest(requestId);
  }
}
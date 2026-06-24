import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/received_requests_repository.dart';

class AcceptRequestUseCase {
  final ReceivedRequestsRepository repository;

  AcceptRequestUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.acceptRequest(id);
  }
}
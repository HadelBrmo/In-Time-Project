import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/received_request_entity.dart';
import '../repository/received_requests_repository.dart';

class GetReceivedRequestsUseCase {
  final ReceivedRequestsRepository repository;

  GetReceivedRequestsUseCase(this.repository);

  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> call() async {
    return await repository.getReceivedRequests();
  }
}
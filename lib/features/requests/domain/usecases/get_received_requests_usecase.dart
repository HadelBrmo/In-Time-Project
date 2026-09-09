import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/received_request_entity.dart';
import '../repository/request_repository.dart';

class GetReceivedRequestsUseCase {
  final RequestRepository repository;

  GetReceivedRequestsUseCase(this.repository);

  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> call() async {
    return await repository.getReceivedRequests();
  }
}

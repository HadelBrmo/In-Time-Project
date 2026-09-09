import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/request_repository.dart';
import '../entity/request_entity.dart';

class RequestCompletionUseCase {
  final RequestRepository repository;
  RequestCompletionUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int requestId) async => await repository.requestCompletion(requestId);
}

class ConfirmCompletionUseCase {
  final RequestRepository repository;
  ConfirmCompletionUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int requestId) async => await repository.confirmCompletion(requestId);
}

class RequestRevisionUseCase {
  final RequestRepository repository;
  RequestRevisionUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int requestId, int days) async => await repository.requestRevision(requestId, days);
}

class DisputeRequestUseCase {
  final RequestRepository repository;
  DisputeRequestUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int requestId) async => await repository.disputeRequest(requestId);
}

class GetPendingConfirmationsUseCase {
  final RequestRepository repository;
  GetPendingConfirmationsUseCase(this.repository);
  Future<Either<Failure, List<RequestEntity>>> call() async => await repository.getPendingConfirmations();
}

import 'package:dartz/dartz.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/error/failures.dart';
import '../entity/request_entity.dart';
import '../entity/received_request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<RequestEntity>>> getMyRequests({RequestStatus? status});
  Future<Either<Failure, String>> createServingRequest({
    required int servingId,
    String? message,
    int? automaticallyCancelAfter,
  });
  Future<Either<Failure, String>> deleteRequest(int requestId);

  // Received Requests Methods
  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> getReceivedRequests();
  Future<Either<Failure, Unit>> acceptRequest(int id);
  Future<Either<Failure, Unit>> rejectRequest(int id);
  Future<Either<Failure, Unit>> requestCompletion(int requestId);
  Future<Either<Failure, Unit>> confirmCompletion(int requestId);
  Future<Either<Failure, Unit>> requestRevision(int requestId, int days);
  Future<Either<Failure, Unit>> disputeRequest(int requestId);
  Future<Either<Failure, List<RequestEntity>>> getPendingConfirmations();
}

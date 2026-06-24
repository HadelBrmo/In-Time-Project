import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<RequestEntity>>> getMyRequests();
  Future<Either<Failure, String>> createServingRequest({
    required int servingId,
    String? message,
  });
  Future<Either<Failure, String>> deleteRequest(int requestId);
}
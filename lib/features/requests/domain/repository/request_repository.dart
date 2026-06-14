import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<RequestEntity>>> getMyRequests();
}
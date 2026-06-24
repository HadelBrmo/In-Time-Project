import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/received_request_entity.dart';

abstract class ReceivedRequestsRepository {
  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> getReceivedRequests();
  Future<Either<Failure, Unit>> acceptRequest(int id);
  Future<Either<Failure, Unit>> rejectRequest(int id);
}
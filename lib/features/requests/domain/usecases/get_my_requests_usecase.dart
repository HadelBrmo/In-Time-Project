import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/request_entity.dart';
import '../repository/request_repository.dart';


import '../entity/request_status.dart';


class GetMyRequestsUseCase {
  final RequestRepository repository;

  GetMyRequestsUseCase({required this.repository});

  Future<Either<Failure, List<RequestEntity>>> call({RequestStatus? status}) async {
    return await repository.getMyRequests(status: status);
  }
}
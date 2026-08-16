import 'package:dartz/dartz.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/error/failures.dart';
import '../entity/request_entity.dart';
import '../repository/request_repository.dart';


class GetMyRequestsUseCase {
  final RequestRepository repository;

  GetMyRequestsUseCase({required this.repository});

  Future<Either<Failure, List<RequestEntity>>> call({RequestStatus? status}) async {
    return await repository.getMyRequests(status: status);
  }
}

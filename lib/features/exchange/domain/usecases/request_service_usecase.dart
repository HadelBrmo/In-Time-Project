import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exchange_request_entity.dart';

class RequestServiceUseCase implements UseCase<ExchangeRequestEntity, RequestParams> {
  @override
  Future<Either<Failure, ExchangeRequestEntity>> call(RequestParams params) async {
    throw UnimplementedError();
  }
}

class RequestParams {
  final String serviceId;

  RequestParams({required this.serviceId});
}
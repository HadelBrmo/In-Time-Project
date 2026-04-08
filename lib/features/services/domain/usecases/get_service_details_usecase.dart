import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/service_entity.dart';

class GetServiceDetailsUseCase implements UseCase<ServiceEntity, GetServiceParams> {
  @override
  Future<Either<Failure, ServiceEntity>> call(GetServiceParams params) async {
    throw UnimplementedError();
  }
}

class GetServiceParams {
  final String serviceId;

  GetServiceParams({required this.serviceId});
}
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/service_entity.dart';

class AddServiceUseCase implements UseCase<ServiceEntity, AddServiceParams> {
  // يستخدم Strategy هنا
  @override
  Future<Either<Failure, ServiceEntity>> call(AddServiceParams params) async {
    throw UnimplementedError();
  }
}

class AddServiceParams {
  final ServiceEntity service;

  AddServiceParams({required this.service});
}
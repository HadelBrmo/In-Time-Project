// features/services/domain/usecases/add_service_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/service_entity.dart';
import '../../repository/servicesRepository.dart';

class AddServiceUseCase {
  final ServicesRepository repository;

  AddServiceUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required ServiceEntity service,
    required XFile? image,
    required String endpoint,
  }) async {
    return await repository.addService(service: service, image: image, endpoint: endpoint);
  }
}
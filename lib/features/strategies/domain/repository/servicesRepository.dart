// features/services/domain/repositories/services_repository.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entity/service_entity.dart';

abstract class ServicesRepository {
  Future<Either<Failure, Unit>> addService({
    required ServiceEntity service,
    required XFile? image,
  });
}
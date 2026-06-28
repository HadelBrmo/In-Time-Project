import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entity/payment_unit_entity.dart';
import '../entity/service_entity.dart';

abstract class ServicesRepository {
  Future<Either<Failure, Unit>> addService({
    required ServiceEntity service,
    required XFile? image,
    required String endpoint,
  });

  Future<Either<Failure, List<PaymentUnitEntity>>> getPaymentUnits();

  Future<Either<Failure, ServiceEntity>> getServiceDetails(int serviceId);
}

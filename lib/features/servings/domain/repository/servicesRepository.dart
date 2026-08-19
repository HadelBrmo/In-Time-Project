import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entity/category_entity.dart';
import '../entity/payment_unit_entity.dart';
import '../entity/service_entity.dart';

abstract class ServicesRepository {
  Future<Either<Failure, Unit>> addService({
    required ServiceEntity service,
    required XFile? image,
    required String endpoint,
  });

  Future<Either<Failure, List<PaymentUnitEntity>>> getPaymentUnits();

  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, ServiceEntity>> getServiceDetails(int serviceId);

  Future<Either<Failure, List<dynamic>>> getAvailabilitySlots(int serviceId);

  Future<Either<Failure, List<ServiceEntity>>> getMyServings();

  Future<Either<Failure, Unit>> updateServing({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  });

  Future<Either<Failure, Unit>> toggleServingStatus(int id, bool isActive);
}

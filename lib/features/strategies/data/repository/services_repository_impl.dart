// features/services/data/repositories/services_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/payment_unit_entity.dart';
import '../../domain/entity/service_entity.dart';
import '../../domain/repository/servicesRepository.dart';
import '../datasources/services_remote_data_source.dart';
import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> addService({
    required ServiceEntity service,
    required XFile? image,
    required String endpoint,
  }) async {
    final serviceModel = ServiceModel(
      title: service.title,
      description: service.description,
      categoryId: service.categoryId,
      costAmount: service.costAmount,
      unitId: service.unitId,
      locationAddress: service.locationAddress,
      locationLat: service.locationLat,
      locationLng: service.locationLng,
      meetingType: service.meetingType,

    );

    try {
      await remoteDataSource.addService(
        serviceModel: serviceModel,
        image: image,
        endpoint: endpoint,
      );
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure() as Failure);
    }
  }

  @override
  Future<Either<Failure, List<PaymentUnitEntity>>> getPaymentUnits() async {
    try {
      final result = await remoteDataSource.getPaymentUnits();
      return Right(result);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(message: e.message));
    } catch (e) {
      return Left(ServerFailure() as Failure);
    }
  }
}

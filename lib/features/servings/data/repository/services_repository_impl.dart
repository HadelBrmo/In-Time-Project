import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/category_entity.dart';
import '../../domain/entity/payment_unit_entity.dart';
import '../../domain/entity/service_entity.dart';
import '../../domain/entity/serving_type_entity.dart';
import '../../domain/repository/services_repository.dart';
import '../datasources/services_remote_data_source.dart';
import '../datasources/services_local_datasource.dart';
import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;
  final ServicesLocalDataSource localDataSource;

  ServicesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PaymentUnitEntity>>> getPaymentUnits() async {
    try {
      final result = await remoteDataSource.getPaymentUnits();
      await localDataSource.cachePaymentUnits(result);
      return Right(result);
    } catch (e) {
      final localData = await localDataSource.getCachedPaymentUnits();
      if (localData.isNotEmpty) {
        return Right(localData);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(result);
      return Right(result);
    } catch (e) {
      final localData = await localDataSource.getCachedCategories();
      if (localData.isNotEmpty) {
        return Right(localData);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServingTypeEntity>>> getServingTypes() async {
    try {
      final result = await remoteDataSource.getServingTypes();
      return Right(result);
    } catch (e) {
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceDetails(int serviceId) async {
    try {
      final result = await remoteDataSource.getServiceDetails(serviceId);
      await localDataSource.cacheServiceDetails(result);
      return Right(result);
    } catch (e) {
      final localData = await localDataSource.getCachedServiceDetails(serviceId);
      if (localData != null) {
        return Right(localData);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getAvailabilitySlots(int serviceId) async {
    try {
      final result = await remoteDataSource.getAvailabilitySlots(serviceId);
      return Right(result);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getMyServings() async {
    try {
      final result = await remoteDataSource.getMyServings();
      await localDataSource.cacheMyServings(result);
      return Right(result);
    } catch (e) {
      final localData = await localDataSource.getCachedMyServings();
      if (localData.isNotEmpty) {
        return Right(localData);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateServing({
    required int id,
    required String title,
    required String description,
    required double costAmount,
    required String meetingType,
  }) async {
    try {
      await remoteDataSource.updateServing(
        id: id,
        title: title,
        description: description,
        costAmount: costAmount,
        meetingType: meetingType,
      );
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleServingStatus(int id, bool isActive) async {
    try {
      await remoteDataSource.toggleServingStatus(id, isActive);
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> rateServing(int serviceId, double rating) async {
    try {
      await remoteDataSource.rateServing(serviceId, rating);
      return const Right(unit);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(
        statusCode: e.statusCode,
        message: e.message,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

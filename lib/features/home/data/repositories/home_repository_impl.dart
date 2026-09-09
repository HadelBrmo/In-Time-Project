import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../servings/domain/entity/service_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasources.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> searchServings({
    int? servingTypeId,
    int? paymentUnitId,
    int? servingCategoryId,
    String? name,
    int? skip,
    int? take,
  }) async {
    try {
      final remoteServings = await remoteDataSource.searchServings(
        servingTypeId: servingTypeId,
        paymentUnitId: paymentUnitId,
        servingCategoryId: servingCategoryId,
        name: name,
        skip: skip,
        take: take,
      );

      await localDataSource.cacheSearchServings(remoteServings);
      return Right(remoteServings);
    } catch (e) {
      final localServings = await localDataSource.getCachedSearchServings();
      if (localServings.isNotEmpty) {
        return Right(localServings);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(statusCode: e.statusCode, message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getNearbyServings({
    required double lat,
    required double lng,
    required int skip,
    required int take,
  }) async {
    try {
      final remoteData = await remoteDataSource.getNearbyServings(
        lat: lat,
        lng: lng,
        skip: skip,
        take: take,
      );
      await localDataSource.cacheNearbyServings(remoteData);
      return Right(remoteData);
    } catch (e) {
      final localData = await localDataSource.getCachedNearbyServings();
      if (localData.isNotEmpty) {
        return Right(localData);
      }
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(statusCode: e.statusCode, message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getProposedServings({
    required int skip,
    required int take,
  }) async {
    try {
      final remoteData = await remoteDataSource.getProposedServings(
        skip: skip,
        take: take,
      );
      return Right(remoteData);
    } catch (e) {
      if (e is ServerExceptionWithDetails) {
        return Left(ServerFailureWithDetails(statusCode: e.statusCode, message: e.message));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateServiceAvailability({
    required int serviceId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await remoteDataSource.updateServiceAvailability(serviceId: serviceId, data: data);
      return const Right(null);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(statusCode: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

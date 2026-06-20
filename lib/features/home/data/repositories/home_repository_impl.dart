import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasources.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServicingEntity>>> searchServings({
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

      return Right(remoteServings);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
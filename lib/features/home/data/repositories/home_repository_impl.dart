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
  }) async {
    try {
      final remoteServings = await remoteDataSource.searchServings(
        servingTypeId: servingTypeId,
        paymentUnitId: paymentUnitId,
        servingCategoryId: servingCategoryId,
        name: name,
      );

      final List<ServicingEntity> servingsList = remoteServings
          .map((model) => ServicingEntity(
                title: model.title,
                description: model.description,
                categoryId: model.categoryId,
                costAmount: model.costAmount,
                unitId: model.unitId,
                locationAddress: model.locationAddress,
                locationLat: model.locationLat,
                locationLng: model.locationLng,
                meetingType: model.meetingType,
                imageUrl: model.imageUrl,
                userFullName: model.userFullName,
                categoryName: model.categoryName,
                unitName: model.unitName,
                servingTypeName: model.servingTypeName,
              ))
          .toList();

      return Right(servingsList);
    }  catch (e, stackTrace) {
  print("🚨 Error in HomeRepositoryImpl: $e");
  print("❌ StackTrace: $stackTrace");
  return Left(ServerFailure());
}
  }
}
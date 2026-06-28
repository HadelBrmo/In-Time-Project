// lib/features/my_servings/data/repository/my_servings_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repository/my_servings_repository.dart';
import '../../domain/entity/my_serving_entity.dart';
import '../datasources/my_servings_remote_data_source.dart';
import '../models/my_serving_model.dart';

class MyServingsRepositoryImpl implements MyServingsRepository {
  final MyServingsRemoteDataSource remoteDataSource;
  MyServingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyServingEntity>>> getMyServings() async {
    try {
      final remoteData = await remoteDataSource.getMyServings();
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailureWithDetails(message: "حدث خطأ غير متوقع"));
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
      final model = MyServingModel(
        id: id,
        title: title,
        description: description,
        costAmount: costAmount,
        meetingType: meetingType,
        createdAt: '',
        servingTypeName: '',
        unitName: '',
      );

      await remoteDataSource.updateServing(id, model);
      return const Right(unit);
    } on ServerException catch (e) {
      // 🛠️ التعديل: تمرير رسالة الخطأ هنا أيضاً
      return Left(ServerFailureWithDetails(message: 'حدث خطا في السيرفر'));
    }
  }
}
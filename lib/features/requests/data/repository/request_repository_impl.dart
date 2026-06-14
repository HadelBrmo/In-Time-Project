import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/request_entity.dart';
import '../../domain/repository/request_repository.dart';
import '../datasource/request_remote_datasource.dart';


class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RequestEntity>>> getMyRequests() async {
    try {
      final remoteRequests = await remoteDataSource.getMyRequests();
      return Right(remoteRequests);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "حدث خطأ غير متوقع";
      final statusCode = e.response?.statusCode;

      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createServingRequest({
    required int servingId,
    String? message,
  }) async {
    try {
      final resultMessage = await remoteDataSource.createServingRequest(
        servingId: servingId,
        message: message,
      );
      return Right(resultMessage);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
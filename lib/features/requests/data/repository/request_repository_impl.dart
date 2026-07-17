import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/request_entity.dart';
import '../../domain/entity/received_request_entity.dart';
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
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createServingRequest({
    required int servingId,
    String? message,
    int? automaticallyCancelAfter,
  }) async {
    try {
      final resultMessage = await remoteDataSource.createServingRequest(
        servingId: servingId,
        message: message,
        automaticallyCancelAfter: automaticallyCancelAfter,
      );
      return Right(resultMessage);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteRequest(int requestId) async {
    try {
      final resultMessage = await remoteDataSource.deleteRequest(requestId);
      return Right(resultMessage);
    } on DioException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> getReceivedRequests() async {
    try {
      final result = await remoteDataSource.getReceivedRequests();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptRequest(int id) async {
    try {
      await remoteDataSource.acceptRequest(id);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectRequest(int id) async {
    try {
      await remoteDataSource.rejectRequest(id);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/received_request_entity.dart';
import '../../domain/repository/received_requests_repository.dart';
import '../datasources/received_requests_remote_datasource.dart';

class ReceivedRequestsRepositoryImpl implements ReceivedRequestsRepository {
  final ReceivedRequestsRemoteDataSource remoteDataSource;

  ReceivedRequestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReceivedRequestGroupEntity>>> getReceivedRequests() async {
    try {
      final remoteData = await remoteDataSource.getReceivedRequests();
      return Right(remoteData);
    } on DioException {
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
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectRequest(int id) async {
    try {
      await remoteDataSource.rejectRequest(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
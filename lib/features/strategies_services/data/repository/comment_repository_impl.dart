// features/services/data/repositories/comment_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/comment_entity.dart';
import '../../domain/repository/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsForServing(int servingId) async {
    try {
      final remoteComments = await remoteDataSource.getCommentsForServing(servingId);
      return Right(remoteComments);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addCommentOnServing({required int servingId, required String content}) async {
    try {
      await remoteDataSource.addCommentOnServing(servingId, content);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> replyToComment({required int commentId, required String content}) async {
    try {
      await remoteDataSource.replyToComment(commentId, content);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getRepliesForComment(int commentId) async {
    try {
      final remoteReplies = await remoteDataSource.getCommentsForServing(commentId); // أو التابع المخصص للردود
      return Right(remoteReplies);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> reactLike(int commentId) async {
    try {
      await remoteDataSource.reactLike(commentId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> reactDislike(int commentId) async {
    try {
      await remoteDataSource.reactDislike(commentId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
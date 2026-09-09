// features/services/domain/repositories/comment_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/comment_entity.dart';


abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getCommentsForServing(int servingId);

  Future<Either<Failure, Unit>> addCommentOnServing({required int servingId, required String content});

  Future<Either<Failure, Unit>> replyToComment({required int commentId, required String content});

  Future<Either<Failure, List<CommentEntity>>> getRepliesForComment(int commentId);

  Future<Either<Failure, Unit>> reactLike(int commentId);

  Future<Either<Failure, Unit>> reactDislike(int commentId);
}
// features/services/domain/usecases/reply_to_comment_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repository/comment_repository.dart';


class ReplyToCommentUseCase {
  final CommentRepository repository;

  ReplyToCommentUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int commentId, required String content}) async {
    return await repository.replyToComment(commentId: commentId, content: content);
  }
}
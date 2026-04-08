import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';

class ReplyToCommentUseCase implements UseCase<CommentEntity, ReplyParams> {
  @override
  Future<Either<Failure, CommentEntity>> call(ReplyParams params) async {
    throw UnimplementedError();
  }
}

class ReplyParams {
  final String parentCommentId;
  final String text;

  ReplyParams({required this.parentCommentId, required this.text});
}
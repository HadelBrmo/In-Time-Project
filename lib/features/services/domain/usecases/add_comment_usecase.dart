import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';

class AddCommentUseCase implements UseCase<CommentEntity, AddCommentParams> {
  @override
  Future<Either<Failure, CommentEntity>> call(AddCommentParams params) async {
    throw UnimplementedError();
  }
}

class AddCommentParams {
  final String serviceId;
  final String text;

  AddCommentParams({required this.serviceId, required this.text});
}
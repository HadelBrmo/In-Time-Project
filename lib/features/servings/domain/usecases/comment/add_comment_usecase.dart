// features/services/domain/usecases/add_comment_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repository/comment_repository.dart';


class AddCommentOnServingUseCase {
  final CommentRepository repository;

  AddCommentOnServingUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int servingId, required String content}) async {
    return await repository.addCommentOnServing(servingId: servingId, content: content);
  }
}
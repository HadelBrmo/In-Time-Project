// features/services/domain/usecases/get_comments_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entity/comment_entity.dart';
import '../../repository/comment_repository.dart';


class GetCommentsForServingUseCase {
  final CommentRepository repository;

  GetCommentsForServingUseCase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call(int servingId) async {
    return await repository.getCommentsForServing(servingId);
  }
}
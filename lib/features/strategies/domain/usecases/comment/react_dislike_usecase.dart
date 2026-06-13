// features/services/domain/usecases/react_dislike_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repository/comment_repository.dart';


class ReactDislikeUseCase {
  final CommentRepository repository;

  ReactDislikeUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int commentId) async {
    return await repository.reactDislike(commentId);
  }
}
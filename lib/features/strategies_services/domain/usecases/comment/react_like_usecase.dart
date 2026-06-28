// features/services/domain/usecases/react_like_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../repository/comment_repository.dart';


class ReactLikeUseCase {
  final CommentRepository repository;

  ReactLikeUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int commentId) async {
    return await repository.reactLike(commentId);
  }
}
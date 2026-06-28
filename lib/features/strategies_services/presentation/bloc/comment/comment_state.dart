// features/services/presentation/comment_bloc/comment_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entity/comment_entity.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitialState extends CommentState {}

class CommentsLoadingState extends CommentState {}

class CommentsLoadedState extends CommentState {
  final List<CommentEntity> comments;
  const CommentsLoadedState(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentsErrorState extends CommentState {
  final String message;
  const CommentsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentActionSubmittingState extends CommentState {}

class CommentActionSuccessState extends CommentState {}
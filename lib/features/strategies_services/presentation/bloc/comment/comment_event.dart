// features/services/presentation/comment_bloc/comment_event.dart
import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class FetchCommentsEvent extends CommentEvent {
  final int servingId;
  const FetchCommentsEvent(this.servingId);

  @override
  List<Object?> get props => [servingId];
}

class AddCommentEvent extends CommentEvent {
  final int servingId;
  final String content;
  const AddCommentEvent({required this.servingId, required this.content});

  @override
  List<Object?> get props => [servingId, content];
}

class ReplyToCommentEvent extends CommentEvent {
  final int commentId;
  final String content;
  const ReplyToCommentEvent({required this.commentId, required this.content});

  @override
  List<Object?> get props => [commentId, content];
}

class LikeCommentEvent extends CommentEvent {
  final int commentId;
  const LikeCommentEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}


class DislikeCommentEvent extends CommentEvent {
  final int commentId;
  const DislikeCommentEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}
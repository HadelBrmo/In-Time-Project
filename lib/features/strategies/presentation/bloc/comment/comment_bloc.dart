// features/services/presentation/comment_bloc/comment_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/comment/add_comment_usecase.dart';
import '../../../domain/usecases/comment/get_comments_usecase.dart';
import '../../../domain/usecases/comment/react_dislike_usecase.dart';
import '../../../domain/usecases/comment/react_like_usecase.dart';
import '../../../domain/usecases/comment/reply_to_comment_usecase.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsForServingUseCase getCommentsUseCase;
  final AddCommentOnServingUseCase addCommentUseCase;
  final ReplyToCommentUseCase replyToCommentUseCase;
  final ReactLikeUseCase reactLikeUseCase;
  final ReactDislikeUseCase reactDislikeUseCase;

  CommentBloc({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.replyToCommentUseCase,
    required this.reactLikeUseCase,
    required this.reactDislikeUseCase,
  }) : super(CommentInitialState()) {

    on<FetchCommentsEvent>((event, emit) async {
      emit(CommentsLoadingState());
      final result = await getCommentsUseCase(event.servingId);
      result.fold(
            (failure) => emit(const CommentsErrorState("حدث خطأ أثناء تحميل التعليقات")),
            (comments) => emit(CommentsLoadedState(comments)),
      );
    });

    on<AddCommentEvent>((event, emit) async {
      final result = await addCommentUseCase(servingId: event.servingId, content: event.content);
      result.fold(
            (failure) => emit(const CommentsErrorState("فشل إرسال التعليق")),
            (_) {
          emit(CommentActionSuccessState());
          add(FetchCommentsEvent(event.servingId));
        },
      );
    });

    on<ReplyToCommentEvent>((event, emit) async {
      final result = await replyToCommentUseCase(commentId: event.commentId, content: event.content);
      result.fold(
            (failure) => emit(const CommentsErrorState("فشل إرسال الرد")),
            (_) => emit(CommentActionSuccessState()),
      );
    });



    on<LikeCommentEvent>((event, emit) async {
      if (state is CommentsLoadedState) {
        final currentState = state as CommentsLoadedState;

        final updatedComments = currentState.comments.map((comment) {
          if (comment.id == event.commentId) {
            return comment.copyWith(
              likesCount: comment.likesCount + 1,
            );
          }
          return comment;
        }).toList();

        emit(CommentsLoadedState(updatedComments));

        final result = await reactLikeUseCase(event.commentId);
        result.fold(
              (failure) {
            emit(CommentsLoadedState(currentState.comments));
          },
              (_) => null,
        );
      }
    });

    on<DislikeCommentEvent>((event, emit) async {
      if (state is CommentsLoadedState) {
        final currentState = state as CommentsLoadedState;

        final updatedComments = currentState.comments.map((comment) {
          if (comment.id == event.commentId) {
            return comment.copyWith(
              dislikesCount: comment.dislikesCount + 1,
            );
          }
          return comment;
        }).toList();

        emit(CommentsLoadedState(updatedComments));

        final result = await reactDislikeUseCase(event.commentId);
        result.fold(
              (failure) => emit(CommentsLoadedState(currentState.comments)),
              (_) => null,
        );
      }
    });
  }
}
// features/services/data/datasources/comment_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getCommentsForServing(int servingId);
  Future<void> addCommentOnServing(int servingId, String content);
  Future<void> replyToComment(int commentId, String content);
  Future<List<CommentModel>> getRepliesForComment(int commentId);
  Future<void> reactLike(int commentId);
  Future<void> reactDislike(int commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final Dio dio;

  CommentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CommentModel>> getCommentsForServing(int servingId) async {
    final response = await dio.get(
      '/servings/$servingId/comments',
      queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
    );

    if (response.statusCode == 200) {
      final List<dynamic> commentsJson = response.data['data'];
      return commentsJson.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> addCommentOnServing(int servingId, String content) async {
    final response = await dio.post(
      '/servings/$servingId/comments',
      data: {'content': content},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> replyToComment(int commentId, String content) async {
    final response = await dio.post(
      '/comments/$commentId/reply',
      data: {'content': content},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<List<CommentModel>> getRepliesForComment(int commentId) async {
    final response = await dio.get('/comments/$commentId/replies');

    if (response.statusCode == 200) {
      final List<dynamic> repliesJson = response.data['data'];
      return repliesJson.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> reactLike(int commentId) async {
    final response = await dio.post('/comments/$commentId/like', data: {});
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> reactDislike(int commentId) async {
    final response = await dio.post('/comments/$commentId/dislike', data: {});
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }
  }
}
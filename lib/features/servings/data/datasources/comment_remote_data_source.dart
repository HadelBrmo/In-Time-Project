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
    try {
      final response = await dio.get(
        '/servings/$servingId/comments',
        queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsJson = response.data['data'];
        return commentsJson.map((json) => CommentModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل التعليقات',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل التعليقات',
      );
    }
  }

  @override
  Future<void> addCommentOnServing(int servingId, String content) async {
    try {
      final response = await dio.post(
        '/servings/$servingId/comments',
        data: {'content': content},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل إضافة التعليق',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر إضافة التعليق',
      );
    }
  }

  @override
  Future<void> replyToComment(int commentId, String content) async {
    try {
      final response = await dio.post(
        '/comments/$commentId/reply',
        data: {'content': content},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل إضافة الرد',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر إضافة الرد',
      );
    }
  }

  @override
  Future<List<CommentModel>> getRepliesForComment(int commentId) async {
    try {
      final response = await dio.get('/comments/$commentId/replies');

      if (response.statusCode == 200) {
        final List<dynamic> repliesJson = response.data['data'];
        return repliesJson.map((json) => CommentModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل الردود',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل الردود',
      );
    }
  }

  @override
  Future<void> reactLike(int commentId) async {
    try {
      final response = await dio.post('/comments/$commentId/react', data: {'type': 'like'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل الإعجاب',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر الإعجاب',
      );
    }
  }

  @override
  Future<void> reactDislike(int commentId) async {
    try {
      final response = await dio.post('/comments/$commentId/react', data: {'type': 'dislike'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerExceptionWithDetails.fromResponse(
          response,
          fallback: 'فشل عدم الإعجاب',
        );
      }
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر عدم الإعجاب',
      );
    }
  }
}
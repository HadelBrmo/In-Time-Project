// features/services/data/models/comment_model.dart

import '../../domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.content,
    required super.userId,
    required super.userFullName,
    required super.depth,
    required super.repliesCount,
    required super.likesCount,
    required super.dislikesCount,
    required super.canAddReply,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>? ?? {};
    final reactions = json['reaction_counts'] as Map<String, dynamic>? ?? {};

    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      userId: userData['id'] ?? 0,
      userFullName: userData['full_name'] ?? 'مستخدم غير معروف',
      depth: json['depth'] ?? 0,
      repliesCount: json['replies_count'] ?? 0,
      likesCount: reactions['like'] ?? 0,
      dislikesCount: reactions['dislike'] ?? 0,
      canAddReply: json['can_add_reply'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'user': {
        'id': userId,
        'full_name': userFullName,
      },
      'depth': depth,
      'replies_count': repliesCount,
      'reaction_counts': {
        'like': likesCount,
        'dislike': dislikesCount,
      },
      'can_add_reply': canAddReply,
      'created_at': createdAt,
    };
  }
}
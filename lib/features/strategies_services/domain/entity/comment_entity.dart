// features/services/domain/entities/comment_entity.dart
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final int id;
  final String content;
  final int userId;
  final String userFullName;
  final int depth;
  final int repliesCount;
  final int likesCount;
  final int dislikesCount;
  final bool canAddReply;
  final String createdAt;

  const CommentEntity({
    required this.id,
    required this.content,
    required this.userId,
    required this.userFullName,
    required this.depth,
    required this.repliesCount,
    required this.likesCount,
    required this.dislikesCount,
    required this.canAddReply,
    required this.createdAt,
  });

  CommentEntity copyWith({
    int? id,
    String? content,
    int? userId,
    String? userFullName,
    int? depth,
    int? repliesCount,
    int? likesCount,
    int? dislikesCount,
    bool? canAddReply,
    String? createdAt,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      depth: depth ?? this.depth,
      repliesCount: repliesCount ?? this.repliesCount,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      canAddReply: canAddReply ?? this.canAddReply,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    content,
    userId,
    userFullName,
    depth,
    repliesCount,
    likesCount,
    dislikesCount,
    canAddReply,
    createdAt,
  ];
}
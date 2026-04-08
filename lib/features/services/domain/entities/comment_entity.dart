class CommentEntity {
  final String id;
  final String text;
  final String authorId;
  final DateTime createdAt;

  CommentEntity({required this.id, required this.text, required this.authorId, required this.createdAt});
}
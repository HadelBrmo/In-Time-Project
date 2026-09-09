class ComplaintRequest {
  final int servingId;
  final int accusedUserId;
  final String reason;
  final String description;
  final List<String> documentPaths;

  const ComplaintRequest({
    required this.servingId,
    required this.accusedUserId,
    required this.reason,
    required this.description,
    this.documentPaths = const [],
  });

  Map<String, dynamic> toJson() => {
        'serving_id': servingId,
        'accused_user_id': accusedUserId,
        'reason': reason,
        'description': description,
      };
}

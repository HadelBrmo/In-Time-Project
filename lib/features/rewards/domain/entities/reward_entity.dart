class RewardEntity {
  final int id;
  final int userId;
  final int hoursAdded;
  final String type;
  final int threshold;
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RewardEntity({
    required this.id,
    required this.userId,
    required this.hoursAdded,
    required this.type,
    required this.threshold,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
  });
}

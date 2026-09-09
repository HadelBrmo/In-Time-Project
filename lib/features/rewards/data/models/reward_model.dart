import '../../domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    required super.userId,
    required super.hoursAdded,
    required super.type,
    required super.threshold,
    required super.reason,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'],
      userId: json['user_id'],
      hoursAdded: json['hours_added'],
      type: json['type'],
      threshold: json['threshold'],
      reason: json['reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hours_added': hoursAdded,
      'type': type,
      'threshold': threshold,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

import '../../domain/entities/leaderboard_user_entity.dart';

class LeaderboardUserModel extends LeaderboardUserEntity {
  const LeaderboardUserModel({
    required super.rank,
    required super.userId,
    required super.fullName,
    super.profilePicture,
    required super.servingTypeId,
    required super.date,
    super.totalHours,
    super.voluntaryHours,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      rank: int.tryParse(json['rank'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      fullName: json['full_name'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
      servingTypeId: int.tryParse(json['serving_type_id'].toString()) ?? 0,
      date: json['date'] as String? ?? '',
      totalHours: int.tryParse(json['total_hours'].toString()) ?? 0,
      voluntaryHours: int.tryParse(json['voluntary_hours'].toString()) ?? 0,
    );
  }
}

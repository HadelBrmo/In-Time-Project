import '../../domain/entities/leaderboard_user_entity.dart';

class LeaderboardUserModel extends LeaderboardUserEntity {
  const LeaderboardUserModel({
    required super.rank,
    required super.userId,
    required super.fullName,
    super.profilePicture,
    required super.servingTypeId,
    required super.date,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      rank: int.tryParse(json['rank'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      fullName: json['full_name'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
      servingTypeId: int.tryParse(json['serving_type_id'].toString()) ?? 0,
      date: json['date'] as String? ?? '',
    );
  }
}

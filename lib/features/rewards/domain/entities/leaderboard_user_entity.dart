import 'package:equatable/equatable.dart';

class LeaderboardUserEntity extends Equatable {
  final int rank;
  final int userId;
  final String fullName;
  final String? profilePicture;
  final int servingTypeId;
  final String date;

  const LeaderboardUserEntity({
    required this.rank,
    required this.userId,
    required this.fullName,
    this.profilePicture,
    required this.servingTypeId,
    required this.date,
  });

  @override
  List<Object?> get props => [rank, userId, fullName, profilePicture, servingTypeId, date];
}

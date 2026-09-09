import 'package:equatable/equatable.dart';

class LeaderboardUserEntity extends Equatable {
  final int rank;
  final int userId;
  final String fullName;
  final String? profilePicture;
  final int servingTypeId;
  final String date;
  final int totalHours;
  final int voluntaryHours;

  const LeaderboardUserEntity({
    required this.rank,
    required this.userId,
    required this.fullName,
    this.profilePicture,
    required this.servingTypeId,
    required this.date,
    this.totalHours = 0,
    this.voluntaryHours = 0,
  });

  @override
  List<Object?> get props => [
        rank,
        userId,
        fullName,
        profilePicture,
        servingTypeId,
        date,
        totalHours,
        voluntaryHours,
      ];
}

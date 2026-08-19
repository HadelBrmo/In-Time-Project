abstract class LeaderboardEvent {}

class FetchLeaderboard extends LeaderboardEvent {
  final int? servingTypeId; // null = كل الأقسام
  final String month; // 'YYYY-MM'

  FetchLeaderboard({this.servingTypeId, required this.month});
}

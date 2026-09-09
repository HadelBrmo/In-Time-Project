import 'package:flutter_bloc/flutter_bloc.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';
import '../../domain/usecases/get_leaderboard_usecase.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

  LeaderboardBloc({required this.getLeaderboardUseCase}) : super(LeaderboardInitial()) {
    on<FetchLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());
      try {
        final users = await getLeaderboardUseCase(
          servingTypeId: event.servingTypeId,
          month: event.month,
        );
        emit(LeaderboardLoaded(users));
      } catch (e) {
        print("❌ [LeaderboardBloc] Error fetching leaderboard: $e");
        String errorMessage = 'تعذر تحميل لوحة الشرف، حاول مرة أخرى';
        if (e is Exception) {
          // يمكن هنا استخراج رسالة الخطأ من السيرفر إذا كانت متوفرة
        }
        emit(LeaderboardError(errorMessage));
      }
    });
  }
}

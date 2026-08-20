import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final GetRewardsUseCase getRewardsUseCase;

  RewardsBloc({required this.getRewardsUseCase}) : super(RewardsInitial()) {
    on<GetMyRewardsEvent>((event, emit) async {
      print("🔔 [RewardsBloc] GetMyRewardsEvent received");
      emit(RewardsLoading());
      
      final result = await getRewardsUseCase();

      switch (result) {
        case Success(data: final resultData):
          print("✅ [RewardsBloc] Success: ${resultData.$1.length} rewards, ${resultData.$2} hours");
          emit(RewardsLoaded(resultData.$1, resultData.$2));
        case FailureResult(failure: final failure):
          print("❌ [RewardsBloc] Failure: ${failure.message}");
          emit(RewardsError(failure.message));
      }
    });
  }
}

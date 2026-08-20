import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final GetRewardsUseCase getRewardsUseCase;

  RewardsBloc({required this.getRewardsUseCase}) : super(RewardsInitial()) {
    on<GetMyRewardsEvent>((event, emit) async {
      emit(RewardsLoading());
      final result = await getRewardsUseCase();

      switch (result) {
        case Success(data: final rewards):
          emit(RewardsLoaded(rewards));
        case FailureResult(failure: final failure):
          emit(RewardsError(failure.message));
      }
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_services_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchServingsUseCase searchServingsUseCase;

  HomeBloc({required this.searchServingsUseCase}) : super(HomeInitialState()) {
    on<FetchHomeServingsEvent>((event, emit) async {
      emit(HomeLoadingState());
      try {
        final servings = await searchServingsUseCase(
          servingTypeId: event.servingTypeId,
          paymentUnitId: event.paymentUnitId,
          servingCategoryId: event.servingCategoryId,
          name: event.name,
        );
        emit(HomeSuccessState(servings: servings));
      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
    });
  }
}
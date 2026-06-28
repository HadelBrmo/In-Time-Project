// lib/features/my_servings/presentation/bloc/my_servings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_servings_usecase.dart';
import '../../domain/usecases/update_serving_usecase.dart';
import 'my_servings_event.dart';
import 'my_servings_state.dart';

class MyServingsBloc extends Bloc<MyServingsEvent, MyServingsState> {
  final GetMyServingsUseCase getMyServingsUseCase;
  final UpdateServingUseCase updateServingUseCase;

  MyServingsBloc({
    required this.getMyServingsUseCase,
    required this.updateServingUseCase,
  }) : super(MyServingsInitialState()) {

    on<FetchMyServingsEvent>((event, emit) async {
      emit(MyServingsLoadingState());
      final result = await getMyServingsUseCase();
      result.fold(
            (failure) => emit(MyServingsErrorState(failure.message)),
            (servings) => emit(MyServingsLoadedState(servings)),
      );
    });

    on<UpdateMyServingEvent>((event, emit) async {
      emit(UpdateServingLoadingState());
      final result = await updateServingUseCase(
        id: event.id,
        title: event.title,
        description: event.description,
        costAmount: event.costAmount,
        meetingType: event.meetingType,
      );
      result.fold(
            (failure) => emit(UpdateServingErrorState(failure.message)),
            (_) => emit(UpdateServingSuccessState()),
      );
    });
  }
}
// lib/features/my_servings/presentation/bloc/my_servings_state.dart
import '../../domain/entity/my_serving_entity.dart';

abstract class MyServingsState {}

class MyServingsInitialState extends MyServingsState {}
class MyServingsLoadingState extends MyServingsState {}
class MyServingsLoadedState extends MyServingsState {
  final List<MyServingEntity> servings;
  MyServingsLoadedState(this.servings);
}
class MyServingsErrorState extends MyServingsState {
  final String message;
  MyServingsErrorState(this.message);
}

class UpdateServingLoadingState extends MyServingsState {}
class UpdateServingSuccessState extends MyServingsState {}
class UpdateServingErrorState extends MyServingsState {
  final String message;
  UpdateServingErrorState(this.message);
}
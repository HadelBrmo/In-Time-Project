import 'package:equatable/equatable.dart';
import '../../../domain/entity/service_entity.dart';

abstract class MyServingsState extends Equatable {
  const MyServingsState();

  @override
  List<Object?> get props => [];
}

class MyServingsInitialState extends MyServingsState {}

class MyServingsLoadingState extends MyServingsState {}

class MyServingsLoadedState extends MyServingsState {
  final List<ServiceEntity> servings;
  const MyServingsLoadedState(this.servings);

  @override
  List<Object?> get props => [servings];
}

class MyServingsErrorState extends MyServingsState {
  final String message;
  const MyServingsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateServingLoadingState extends MyServingsState {}

class UpdateServingSuccessState extends MyServingsState {}

class UpdateServingErrorState extends MyServingsState {
  final String message;
  const UpdateServingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

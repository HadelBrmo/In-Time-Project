import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}
class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<ServicingEntity> servings;
  const HomeSuccessState({required this.servings});

  @override
  List<Object?> get props => [servings];
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateAvailabilitySuccessState extends HomeState {}
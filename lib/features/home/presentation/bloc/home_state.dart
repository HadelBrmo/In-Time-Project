import 'package:equatable/equatable.dart';
import '../../../servings/domain/entity/service_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}
class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<ServiceEntity> servings;
  final List<ServiceEntity> proposedServings;
  final bool hasReachedMax;
  final DateTime? timestamp;

  const HomeSuccessState({
    required this.servings,
    this.proposedServings = const [],
    this.hasReachedMax = false,
    this.timestamp,
  });

  @override
  List<Object?> get props => [servings, proposedServings, hasReachedMax, timestamp];

  HomeSuccessState copyWith({
    List<ServiceEntity>? servings,
    List<ServiceEntity>? proposedServings,
    bool? hasReachedMax,
    DateTime? timestamp,
  }) {
    return HomeSuccessState(
      servings: servings ?? this.servings,
      proposedServings: proposedServings ?? this.proposedServings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateAvailabilitySuccessState extends HomeState {}
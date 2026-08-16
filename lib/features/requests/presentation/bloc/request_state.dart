import 'package:equatable/equatable.dart';
import '../../domain/entity/request_entity.dart';

abstract class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object?> get props => [];
}

class RequestsInitialState extends RequestsState {}

class RequestsLoadingState extends RequestsState {}

class RequestsLoadedState extends RequestsState {
  final List<RequestEntity> requests;
  const RequestsLoadedState(this.requests);

  @override
  List<Object?> get props => [requests];
}

class RequestsErrorState extends RequestsState {
  final String message;
  final int? statusCode;

  const RequestsErrorState({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class CreateRequestLoadingState extends RequestsState {}

class CreateRequestSuccessState extends RequestsState {
  final String message;
  const CreateRequestSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateRequestErrorState extends RequestsState {
  final String errorMessage;
  const CreateRequestErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
class RequestDeletedSuccessState extends RequestsState {}

class RequestActionLoadingState extends RequestsState {}

class RequestActionSuccessState extends RequestsState {
  final String message;
  const RequestActionSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class RequestActionErrorState extends RequestsState {
  final String message;
  const RequestActionErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class PendingConfirmationsLoadedState extends RequestsState {
  final List<RequestEntity> requests;
  const PendingConfirmationsLoadedState(this.requests);
  @override
  List<Object?> get props => [requests];
}

class RequestDeleteErrorState extends RequestsState {
  final String message;
  const RequestDeleteErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
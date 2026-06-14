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
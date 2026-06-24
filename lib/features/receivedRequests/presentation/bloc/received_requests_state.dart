import 'package:equatable/equatable.dart';
import '../../domain/entity/received_request_entity.dart';

abstract class ReceivedRequestsState extends Equatable {
  const ReceivedRequestsState();

  @override
  List<Object?> get props => [];
}

class ReceivedRequestsInitialState extends ReceivedRequestsState {}
class ReceivedRequestsLoadingState extends ReceivedRequestsState {}

class ReceivedRequestsLoadedState extends ReceivedRequestsState {
  final List<ReceivedRequestGroupEntity> requestGroups;
  const ReceivedRequestsLoadedState(this.requestGroups);

  @override
  List<Object?> get props => [requestGroups];
}

class ReceivedRequestsErrorState extends ReceivedRequestsState {
  final String message;
  const ReceivedRequestsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AcceptRequestLoadingState extends ReceivedRequestsState {}
class AcceptRequestSuccessState extends ReceivedRequestsState {}
class AcceptRequestErrorState extends ReceivedRequestsState {
  final String message;
  const AcceptRequestErrorState(this.message);
}

class RejectRequestLoadingState extends ReceivedRequestsState {}
class RejectRequestSuccessState extends ReceivedRequestsState {}
class RejectRequestErrorState extends ReceivedRequestsState {
  final String message;
  const RejectRequestErrorState(this.message);
}
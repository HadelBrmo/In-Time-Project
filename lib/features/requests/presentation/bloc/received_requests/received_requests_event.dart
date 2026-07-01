import 'package:equatable/equatable.dart';

abstract class ReceivedRequestsEvent extends Equatable {
  const ReceivedRequestsEvent();

  @override
  List<Object?> get props => [];
}

class FetchReceivedRequestsEvent extends ReceivedRequestsEvent {}

class AcceptRequestEvent extends ReceivedRequestsEvent {
  final int requestId;
  const AcceptRequestEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class RejectRequestEvent extends ReceivedRequestsEvent {
  final int requestId;
  const RejectRequestEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

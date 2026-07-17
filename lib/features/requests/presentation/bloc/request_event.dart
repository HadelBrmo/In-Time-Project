import 'package:equatable/equatable.dart';

abstract class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyRequestsEvent extends RequestsEvent {}

class CreateServingRequestEvent extends RequestsEvent {
  final int servingId;
  final String? message;
  final int? automaticallyCancelAfter;

  const CreateServingRequestEvent({
    required this.servingId,
    this.message,
    this.automaticallyCancelAfter,
  });

  @override
  List<Object?> get props => [servingId, message, automaticallyCancelAfter];
}

class DeleteRequestEvent extends RequestsEvent {
  final int requestId;

  const DeleteRequestEvent({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}
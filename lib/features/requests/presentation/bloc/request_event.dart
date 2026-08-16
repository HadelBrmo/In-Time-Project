import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

abstract class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyRequestsEvent extends RequestsEvent {
  final RequestStatus? status;

  const FetchMyRequestsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

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
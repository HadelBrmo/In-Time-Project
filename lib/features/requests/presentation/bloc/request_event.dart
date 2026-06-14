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

  const CreateServingRequestEvent({required this.servingId, this.message});

  @override
  List<Object?> get props => [servingId, message];
}
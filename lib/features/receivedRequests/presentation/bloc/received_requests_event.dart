import 'package:equatable/equatable.dart';

abstract class ReceivedRequestsEvent extends Equatable {
  const ReceivedRequestsEvent();

  @override
  List<Object?> get props => [];
}

class FetchReceivedRequestsEvent extends ReceivedRequestsEvent {}
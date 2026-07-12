import 'package:equatable/equatable.dart';

import '../../data/models/complaint_model.dart';


abstract class ComplaintState extends Equatable {
  const ComplaintState();
  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintSubmitting extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  final ComplaintResponse response;
  const ComplaintSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class ComplaintError extends ComplaintState {
  final String message;
  const ComplaintError(this.message);
  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';
import '../../data/models/complaint_request.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();
  @override
  List<Object?> get props => [];
}

class SubmitComplaintEvent extends ComplaintEvent {
  final ComplaintRequest request;

  const SubmitComplaintEvent(this.request);
  @override
  List<Object?> get props => [request];
}
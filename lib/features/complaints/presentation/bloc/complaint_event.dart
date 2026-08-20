import 'package:equatable/equatable.dart';
import '../../data/models/complaint_request.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();
  @override
  List<Object?> get props => [];
}

class SubmitComplaintEvent extends ComplaintEvent {
  final ComplaintRequest request;
  final List<String> documentPaths;

  const SubmitComplaintEvent(this.request, {this.documentPaths = const []});
  @override
  List<Object?> get props => [request, documentPaths];
}

// ✅ الإضافة الجديدة التي كانت تسبب الخطأ
class FetchMyComplaintsEvent extends ComplaintEvent {}
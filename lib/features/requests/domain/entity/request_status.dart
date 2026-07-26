import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
  completionRequested,
  completed,
  canceled,
  disputed;

  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'completion_requested':
        return RequestStatus.completionRequested;
      case 'completed':
        return RequestStatus.completed;
      case 'canceled':
        return RequestStatus.canceled;
      case 'disputed':
        return RequestStatus.disputed;
      default:
        return RequestStatus.pending;
    }
  }

  String toJson() {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.completionRequested:
        return 'completion_requested';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.canceled:
        return 'canceled';
      case RequestStatus.disputed:
        return 'disputed';
    }
  }

  String getTranslation(BuildContext context) {
    switch (this) {
      case RequestStatus.pending:
        return context.tr('status_pending');
      case RequestStatus.accepted:
        return context.tr('status_accepted');
      case RequestStatus.rejected:
        return context.tr('status_rejected');
      case RequestStatus.completionRequested:
        return context.tr('status_completion_requested');
      case RequestStatus.completed:
        return context.tr('status_completed');
      case RequestStatus.canceled:
        return context.tr('status_canceled');
      case RequestStatus.disputed:
        return context.tr('status_disputed');
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return Colors.amber;
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.completionRequested:
        return Colors.blue;
      case RequestStatus.completed:
        return Colors.teal;
      case RequestStatus.canceled:
        return Colors.grey;
      case RequestStatus.disputed:
        return Colors.orange;
    }
  }
}

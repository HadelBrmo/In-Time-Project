import 'package:flutter/material.dart';
import 'app_colors.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
  completion_requested,
  completed,
  canceled,
  unknown;

  static RequestStatus fromString(String? status) {
    if (status == null) return RequestStatus.unknown;
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'completion_requested':
        return RequestStatus.completion_requested;
      case 'completed':
        return RequestStatus.completed;
      case 'canceled':
        return RequestStatus.canceled;
      default:
        return RequestStatus.unknown;
    }
  }

  String get name {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.completion_requested:
        return 'completion_requested';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.canceled:
        return 'canceled';
      case RequestStatus.unknown:
        return 'unknown';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return const Color(0xFFFFB300);
      case RequestStatus.accepted:
        return const Color(0xFF2E7D32);
      case RequestStatus.rejected:
        return const Color(0xFFC62828);
      case RequestStatus.completion_requested:
        return Colors.blue;
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.canceled:
        return Colors.grey;
      case RequestStatus.unknown:
        return AppColors.greyColor;
    }
  }

  String get translation {
    switch (this) {
      case RequestStatus.pending:
        return "قيد الانتظار";
      case RequestStatus.accepted:
        return "مقبول";
      case RequestStatus.rejected:
        return "مرفوض";
      case RequestStatus.completion_requested:
        return "طلب اكتمال";
      case RequestStatus.completed:
        return "مكتمل";
      case RequestStatus.canceled:
        return "ملغي";
      case RequestStatus.unknown:
        return "غير معروف";
    }
  }
}

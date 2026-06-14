import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
  unknown;

  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return RequestStatus.unknown;
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
      case RequestStatus.unknown:
        return AppColors.greyColor;
    }
  }

  String get translation {
    switch (this) {
      case RequestStatus.pending:
        return "قيد الانتظار";
      case RequestStatus.accepted:
        return "تم القبول";
      case RequestStatus.rejected:
        return "مرفوض";
      case RequestStatus.unknown:
        return "غير معروف";
    }
  }
}
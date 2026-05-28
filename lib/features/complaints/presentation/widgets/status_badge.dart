import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String title;
  final ComplaintStatusType type;

  const StatusBadgeWidget({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon(),
            size: 18,
            color: _textColor(),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              color: _textColor(),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    switch (type) {
      case ComplaintStatusType.done:
        return AppColors.secondaryColor.withOpacity(0.12);

      case ComplaintStatusType.processing:
        return AppColors.yellowColor.withOpacity(0.12);

      case ComplaintStatusType.rejected:
        return Colors.red.withOpacity(0.12);
    }
  }

  Color _textColor() {
    switch (type) {
      case ComplaintStatusType.done:
        return AppColors.primaryColor;

      case ComplaintStatusType.processing:
        return AppColors.yellowColor;

      case ComplaintStatusType.rejected:
        return Colors.red;
    }
  }

  IconData _icon() {
    switch (type) {
      case ComplaintStatusType.done:
        return Icons.check;

      case ComplaintStatusType.processing:
        return Icons.error;

      case ComplaintStatusType.rejected:
        return Icons.close;
    }
  }
}

enum ComplaintStatusType {
  done,
  processing,
  rejected,
}


import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

Widget buildReactionIcon({
  required IconData icon,
  required String count,
  required VoidCallback onTap,
  bool isReacted = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(color: AppColors.greyColor, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Icon(
            icon,
            color: isReacted ? AppColors.primaryColor : AppColors.greyColor,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
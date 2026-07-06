import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

Widget buildLanguageOption({required BuildContext context,required String title, required String flag, required bool isSelected, required VoidCallback onTap}) {
  final theme = Theme.of(context);
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(flag, style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 10.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryColor)
        ],
      ),
    ),
  );
}

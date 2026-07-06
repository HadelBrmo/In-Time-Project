import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

Widget buildSectionCard({required BuildContext context, required String title, required IconData icon, required Widget child}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: isDarkMode ? theme.cardColor : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: isDarkMode
            ? AppColors.greyColor
            : AppColors.greyColor.withOpacity(0.2),
        width: 1.w,
      ),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
                icon,
                color: isDarkMode ? theme.iconTheme.color?.withOpacity(0.7) : AppColors.darkGreyColor,
                size: 22.sp
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        Divider(
          height: 20,
          color: isDarkMode ? theme.dividerColor : AppColors.greyColor.withOpacity(0.2),
        ),
        child,
      ],
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

Widget buildSecurityActionRow({
  required BuildContext context,
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 11.sp,
                    color: isDarkMode ? AppColors.whiteColor.withOpacity(0.54) : AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDarkMode ? AppColors.whiteColor.withOpacity(0.38) : AppColors.greyColor,
            size: 14.sp,
          ),
        ],
      ),
    ),
  );
}
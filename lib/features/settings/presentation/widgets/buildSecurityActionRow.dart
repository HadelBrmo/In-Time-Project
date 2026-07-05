import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              color: const Color(0xFF2EC5B6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF2EC5B6), size: 20.sp),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDarkMode ? Colors.white38 : Colors.grey[400],
            size: 14.sp,
          ),
        ],
      ),
    ),
  );
}
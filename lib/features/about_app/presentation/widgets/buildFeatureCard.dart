import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildFeatureCard({
  required BuildContext context,
  required String title,
  required String description,
  required IconData icon,
}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: isDarkMode ? theme.cardColor : Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey[200]!,
        width: 1.w,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2EC5B6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2EC5B6),
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDarkMode ? Colors.white54 : Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
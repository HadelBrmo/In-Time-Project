import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildInfoRow({required BuildContext context, required String value, required String label}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (label.isNotEmpty) ...[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDarkMode ? theme.textTheme.bodySmall?.color : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Text(
                  value,
                  textDirection: TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color ?? (isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 28.h,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: isDarkMode ? theme.dividerColor : Colors.grey[300]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            onPressed: () {},
            child: Text(
              'تعديل',
              style: TextStyle(
                fontSize: 11.sp,
                color: isDarkMode ? theme.textTheme.bodyLarge?.color : Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

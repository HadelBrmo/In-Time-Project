import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class BuildLinkRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const BuildLinkRow({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.whiteColor.withOpacity(0.54) : AppColors.darkGreyColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDarkMode ? AppColors.whiteColor.withOpacity(0.38) : AppColors.greyColor.withOpacity(0.4),
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String rewardType; // 'weekly', 'monthly', 'lifetime'
  final int hours;
  final DateTime date;

  const RewardCard({
    super.key,
    required this.title,
    required this.rewardType,
    required this.hours,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Color startColor;
    Color endColor;
    IconData icon;
    String typeLabel;

    switch (rewardType.toLowerCase()) {
      case 'weekly':
        startColor = const Color(0xFF64B5F6);
        endColor = const Color(0xFF1E88E5);
        icon = Icons.calendar_view_week;
        typeLabel = context.tr('weekly_reward');
        break;
      case 'monthly':
        startColor = const Color(0xFFBA68C8);
        endColor = const Color(0xFF8E24AA);
        icon = Icons.calendar_month;
        typeLabel = context.tr('monthly_reward');
        break;
      case 'lifetime':
      default:
        startColor = const Color(0xFFFFD54F);
        endColor = const Color(0xFFFFA000);
        icon = Icons.workspace_premium;
        typeLabel = context.tr('lifetime_reward');
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                startColor.withOpacity(0.3),
                endColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5.w,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [startColor, endColor]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: startColor.withOpacity(0.5),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 30.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeLabel,
                      style: TextStyle(
                        color: startColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "+$hours",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "HOUR",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

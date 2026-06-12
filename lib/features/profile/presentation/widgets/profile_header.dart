import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/mediaQuery.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final containerColor = isDarkMode ? const Color(0xFF3A3A3A) : AppColors.whiteColor;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.blackColor.withOpacity(0.08);

    final avatarSize = media.width * 0.35;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(media.width * 0.035),
        child: ClipOval(
          child: Center(
            child: Image.asset(
              'assets/images/profile/profile.png',
              fit: BoxFit.cover,
              width: media.width * 0.170,
              height: media.width * 0.170,
            ),
          ),
        ),
      ),
    );
  }
}
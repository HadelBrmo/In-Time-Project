import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor,
       
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: ClipOval(
          child: Center (child:Image.asset('assets/images/profile/profile.png' ,
          fit: BoxFit.cover,
          width: 90,
          height: 90,
          ),
        ),),
      ),
    );
  }
}
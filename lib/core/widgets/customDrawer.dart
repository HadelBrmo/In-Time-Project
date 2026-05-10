import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';

import '../../features/home/presentation/widgets/drawItem.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.whiteColor,
      child: Column(
        children: [
          Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color:  AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50.r),
                topRight:  Radius.circular(50.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47.r,
                    backgroundImage: const AssetImage('assets/images/myPhoto.jpg'),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "هديل برمو",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "hadelbrmo11@gmail.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              children: [
                drawerItem(icon: Icons.settings_outlined, text: "الإعدادات"),
                drawerItem(icon: Icons.brightness_6_outlined, text: "المظهر"),
                drawerItem(icon: Icons.chat_bubble_outline, text: "شكوى"),
                drawerItem(icon: Icons.bookmark_border, text: "المحفوظة"),
                drawerItem(icon: Icons.person_add_alt, text: "دعوة الأصدقاء"),
                drawerItem(icon: Icons.update, text: "تحديث التطبيق"),
                drawerItem(icon: Icons.info_outline, text: "حول التطبيق"),
                drawerItem(icon: Icons.logout, text: "تسجيل الخروج", isExit: true),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

Widget drawerItem({
  required IconData icon,
  required String text,
  VoidCallback? onTap,
  bool isExit = false,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: isExit ? AppColors.greyColor : Colors.grey[700],
      size: 22.sp,
    ),
    title: Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),

    onTap: onTap,
  );
}
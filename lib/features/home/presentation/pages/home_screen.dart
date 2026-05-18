import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import '../../../../core/widgets/customDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: Text(
          "All Services",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 22.sp,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text("محتوى الصفحة الرئيسية (قائمة الخدمات)"),
      ),
    );
  }
}
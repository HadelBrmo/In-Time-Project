import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/injection_container.dart';

import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/wallet/presentation/pages/hours_balance_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 3;

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDarkMode,
  }) {
    final bool isSelected = _currentIndex == index;

    final Color itemColor = isSelected
        ? Colors.white
        : (isDarkMode ? Colors.white.withOpacity(0.55) : Colors.white.withOpacity(0.75));

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: itemColor,
            size: 26.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: itemColor,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> screens = [
      ProfilePage(),
      const Center(child: Text("صفحة لوحة الشرف")),
      HoursBalancePage(),
      const HomeScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/paidStrategyPage");
        },
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 35.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppColors.primaryColor.withOpacity(isDarkMode ? 0.82 : 0.95),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.h,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 65.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildNavItem(icon: Icons.person_outline, label: "الشخصية", index: 0, isDarkMode: isDarkMode),
                  SizedBox(width: 35.w),
                  _buildNavItem(icon: Icons.emoji_events_outlined, label: "لوحة الشرف", index: 1, isDarkMode: isDarkMode),
                ],
              ),
              SizedBox(width: 40.w),
              Row(
                children: [
                  _buildNavItem(icon: Icons.access_time, label: "ساعاتي", index: 2, isDarkMode: isDarkMode),
                  SizedBox(width: 35.w),
                  _buildNavItem(icon: Icons.home_outlined, label: "الرئيسية", index: 3, isDarkMode: isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
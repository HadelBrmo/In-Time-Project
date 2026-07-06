import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/utils/auth_utils.dart';
import 'package:in_time/core/constants/app_colors.dart';

import '../../features/chat/presentation/pages/chats_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
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
    required ThemeData theme,
  }) {
    final bool isSelected = _currentIndex == index;

    final Color itemColor = isSelected
        ? AppColors.whiteColor
        : (isDarkMode ? AppColors.whiteColor.withOpacity(0.55) : AppColors.whiteColor.withOpacity(0.75));

    return InkWell(
      onTap: () {
        if (index == 0 || index == 1 || index == 2) {
          if (!AuthUtils.checkAuth(context)) return;
        }
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
            style: theme.textTheme.titleMedium?.copyWith(
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final List<Widget> screens = [
      const ChatsPage(),
      Center(child: Text(context.tr('leaderboard_page_title'), style: theme.textTheme.titleMedium)),
      const HoursBalancePage(),
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
          if (AuthUtils.checkAuth(context)) {
            Navigator.pushNamed(context, "/paidStrategyPage");
          }
        },
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.whiteColor, size: 35.sp),
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
                  _buildNavItem(theme: theme, icon: Icons.chat, label: context.tr('chat_nav'), index: 0, isDarkMode: isDarkMode),
                  SizedBox(width: 35.w),
                  _buildNavItem(theme: theme, icon: Icons.emoji_events_outlined, label: context.tr('leaderboard_nav'), index: 1, isDarkMode: isDarkMode),
                ],
              ),
              SizedBox(width: 40.w),
              Row(
                children: [
                  _buildNavItem(theme: theme, icon: Icons.access_time, label: context.tr('my_hours_nav'), index: 2, isDarkMode: isDarkMode),
                  SizedBox(width: 35.w),
                  _buildNavItem(theme: theme, icon: Icons.home_outlined, label: context.tr('home_nav'), index: 3, isDarkMode: isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
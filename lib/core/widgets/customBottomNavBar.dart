import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/utils/auth_utils.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/widgets/responsive_layout.dart';

import '../../features/chat/presentation/pages/chats/chats_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/wallet/presentation/pages/hours_balance_page.dart';
import '../../injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 3;
  StreamSubscription? _callListener;

  @override
  void initState() {
    super.initState();
    _startCallListener();
  }

  @override
  void dispose() {
    _callListener?.cancel();
    super.dispose();
  }

  void _startCallListener() {
    final userId = sl<SharedPreferences>().getInt("user_id");
    if (userId == null) return;

    _callListener = FirebaseFirestore.instance
        .collection('rooms')
        .where('receiverId', isEqualTo: userId.toString())
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _showIncomingCallDialog(change.doc);
        }
      }
    });
  }

  void _showIncomingCallDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final callerName = data['callerName'] ?? "Unknown";
    final roomId = doc.id;
    final callerId = data['callerId'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("اتصال فيديو وارد"),
        content: Text("يتصل بك $callerName..."),
        actions: [
          TextButton(
            onPressed: () {
              doc.reference.update({'status': 'ended'});
              Navigator.pop(context);
            },
            child: const Text("رفض", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.videoCallPage,
                arguments: {
                  'chatId': callerId,
                  'chatTitle': callerName,
                  'isIncomingCall': true,
                  'existingRoomId': roomId,
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("قبول"),
          ),
        ],
      ),
    );
  }

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

    return Expanded(
      child: InkWell(
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: itemColor,
                  size: 24.sp,
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: itemColor,
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
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

    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(theme, isDarkMode, screens),
      tabletBody: _buildTabletLayout(theme, isDarkMode, screens),
      desktopBody: _buildTabletLayout(theme, isDarkMode, screens),
    );
  }

  Widget _buildMobileLayout(ThemeData theme, bool isDarkMode, List<Widget> screens) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main_add_btn',
        onPressed: () {
          if (AuthUtils.checkAuth(context)) {
            Navigator.pushNamed(context, "/paidStrategyPage");
          }
        },
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.whiteColor, size: 32.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primaryColor.withOpacity(isDarkMode ? 0.82 : 0.95),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.h,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildNavItem(theme: theme, icon: Icons.chat, label: context.tr('chat_nav'), index: 0, isDarkMode: isDarkMode),
                    _buildNavItem(theme: theme, icon: Icons.emoji_events_outlined, label: context.tr('leaderboard_nav'), index: 1, isDarkMode: isDarkMode),
                  ],
                ),
              ),
              SizedBox(width: 65.w),
              Expanded(
                child: Row(
                  children: [
                    _buildNavItem(theme: theme, icon: Icons.access_time, label: context.tr('my_hours_nav'), index: 2, isDarkMode: isDarkMode),
                    _buildNavItem(theme: theme, icon: Icons.home_outlined, label: context.tr('home_nav'), index: 3, isDarkMode: isDarkMode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme, bool isDarkMode, List<Widget> screens) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.primaryColor.withOpacity(isDarkMode ? 0.82 : 0.95),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              if (index == 0 || index == 1 || index == 2) {
                if (!AuthUtils.checkAuth(context)) return;
              }
              setState(() {
                _currentIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            unselectedIconTheme: IconThemeData(color: AppColors.whiteColor.withOpacity(0.55)),
            selectedIconTheme: const IconThemeData(color: AppColors.whiteColor),
            unselectedLabelTextStyle: TextStyle(color: AppColors.whiteColor.withOpacity(0.55)),
            selectedLabelTextStyle: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            leading: Column(
              children: [
                SizedBox(height: 20.h),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'main_add_btn_tablet',
                  onPressed: () {
                    if (AuthUtils.checkAuth(context)) {
                      Navigator.pushNamed(context, "/paidStrategyPage");
                    }
                  },
                  backgroundColor: AppColors.whiteColor,
                  child: const Icon(Icons.add, color: AppColors.primaryColor),
                ),
                SizedBox(height: 20.h),
              ],
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.chat),
                label: Text(context.tr('chat_nav')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.emoji_events_outlined),
                label: Text(context.tr('leaderboard_nav')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.access_time),
                label: Text(context.tr('my_hours_nav')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                label: Text(context.tr('home_nav')),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}
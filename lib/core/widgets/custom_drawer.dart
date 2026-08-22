import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/app_routes.dart';
import '../../features/about_app/presentation/pages/about_app_page.dart';
import '../../features/home/presentation/widgets/home_widget/draw_item.dart';
import '../../features/servings/presentation/bloc/my_servings/my_servings_bloc.dart';
import '../../features/servings/presentation/pages/my_servings/my_servings_view.dart';
import '../../features/servings/presentation/pages/saved_services/saved_services_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page_03.dart';
import '../../injection_container.dart';
import '../localization/app_localizations.dart';
import '../utils/auth_utils.dart';
import '../utils/dialog_utils.dart';
import '../widgets/global_particles_wrapper.dart';
import 'package:in_time/features/complaints/presentation/pages/complaint_status_list_page.dart'; 

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final drawerBgColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;

    final prefs = sl<SharedPreferences>();
    final String fullName = prefs.getString('full_name') ?? context.tr('guest');
    final String email = prefs.getString('email') ?? "guest@in-time.com";
    final String? profilePic = prefs.getString('profile_picture');
    final bool isVerified = prefs.getBool('is_identity_verified') ?? false;

    final String? fullImageUrl = (profilePic != null && profilePic.isNotEmpty)
        ? (profilePic.startsWith('http')
            ? profilePic
            : 'http://ali.ba-tech.tech/storage/$profilePic')
        : null;

    return Drawer(
      backgroundColor: drawerBgColor,
      child: GlobalParticlesWrapper(
        child: Column(
          children: [
            Container(
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.r),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundColor: AppColors.whiteColor,
                      child: CircleAvatar(
                        radius: 47.r,
                        backgroundImage: fullImageUrl != null
                            ? NetworkImage(fullImageUrl)
                            : const AssetImage('assets/images/profile/profile.png') as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fullName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 20.sp,
                          ),
                        ),
                        if (isVerified) ...[
                          SizedBox(width: 5.w),
                          const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                        ],
                      ],
                    ),
                    Text(
                      email,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fade(duration: 600.ms)
                .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              curve: Curves.fastOutSlowIn,
              duration: 600.ms,
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                children: [
                  drawerItem(
                    icon: Icons.settings_outlined,
                    text: context.tr('settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.person_outline_rounded,
                    text: context.tr('profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profilePage);
                    },
                  ),
                  drawerItem(
                    icon: Icons.receipt_long_rounded,
                    text: context.tr('complaints'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComplaintStatusListPage(),
                        ),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.bookmark_border,
                    text: context.tr('saved'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  SavedServicesPage(),
                        ),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.history,
                    text: context.tr('activity_history'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.myRequestsPage);
                    },
                  ),
                  drawerItem(
                    icon: Icons.business_center,
                    text: context.tr('my_services'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<MyServingsBloc>(
                            create: (context) => sl<MyServingsBloc>(),
                            child: const MyServingsView(),
                          ),
                        ),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.badge_outlined,
                    text: context.tr('identity_verification'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage3(),
                        ),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.info_outline,
                    text: context.tr('about_app'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutAppPage()),
                      );
                    },
                  ),
                  drawerItem(
                    icon: Icons.logout,
                    text: context.tr('logout'),
                    isExit: true,
                    onTap: () {
                      DialogUtils.showConfirmDialog(
                        context: context,
                        title: context.tr('logout_confirmation_title'),
                        message: context.tr('logout_confirmation_message'),
                        confirmText: context.tr('confirm'),
                        cancelText: context.tr('cancel'),
                        onConfirm: () => AuthUtils.logout(context),
                      );
                    },
                  ),
                ].animate(interval: 40.ms)
                    .fade(duration: 350.ms)
                    .slideX(
                    begin: 0.15,
                    end: 0,
                    curve: Curves.easeOutBack,
                    duration: 500.ms
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

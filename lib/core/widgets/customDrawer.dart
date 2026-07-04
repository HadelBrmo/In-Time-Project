import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/app_routes.dart';
import '../../features/home/presentation/widgets/home_widget/drawItem.dart';
import '../../features/servings/presentation/bloc/my_servings/my_servings_bloc.dart';
import '../../features/servings/presentation/pages/my_servings_view.dart';
import '../../injection_container.dart';
import '../utils/auth_utils.dart';
import '../widgets/global_particles_wrapper.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final drawerBgColor = isDarkMode ? AppColors.blackColor : Colors.white;

    final prefs = sl<SharedPreferences>();
    final String fullName = prefs.getString('full_name') ?? "زائر";
    final String email = prefs.getString('email') ?? "guest@in-time.com";
    final String? profilePic = prefs.getString('profile_picture');

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
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 47.r,
                        backgroundImage: fullImageUrl != null
                            ? NetworkImage(fullImageUrl)
                            : const AssetImage('assets/images/profile/profile.png') as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
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
                  drawerItem(icon: Icons.settings_outlined, text: "الإعدادات"),
                  drawerItem(icon: Icons.brightness_6_outlined, text: "المظهر"),
                  drawerItem(
                    icon: Icons.chat_bubble_outline,
                    text: "شكوى",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.submitComplaintPage);
                    },
                  ),
                  drawerItem(icon: Icons.bookmark_border, text: "المحفوظة"),
                  drawerItem(
                    icon: Icons.history,
                    text: "سجل الانشطة",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.myRequestsPage);
                    },
                  ),
                  drawerItem(
                    icon: Icons.business_center,
                    text: "عرض خدماتي",
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
                  drawerItem(icon: Icons.update, text: "تحديث التطبيق"),
                  drawerItem(icon: Icons.info_outline, text: "حول التطبيق"),
                  drawerItem(
                    icon: Icons.logout,
                    text: "تسجيل الخروج",
                    isExit: true,
                    onTap: () => AuthUtils.logout(context),
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

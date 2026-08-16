import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../widgets/build_feature_card.dart';
import '../widgets/build_section_title.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: CustomAppBar(
            title: Text(context.tr('about_app')),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: ResponsiveLayout(
        mobileBody: _buildAboutContent(media, theme, isDarkMode, context),
        tabletBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildAboutContent(media, theme, isDarkMode, context),
          ),
        ),
        desktopBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _buildAboutContent(media, theme, isDarkMode, context),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent(MediaQueryHelper media, ThemeData theme, bool isDarkMode, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/Logo_01.png',
                    height: media.height * 0.16,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'In Time',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24.sp,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    context.tr('about_app_desc'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: isDarkMode ? AppColors.whiteColor.withOpacity(0.7) : AppColors.darkGreyColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          buildSectionTitle(context, context.tr('features_title')),
          SizedBox(height: 12.h),

          buildFeatureCard(
            context: context,
            title: context.tr('feature_1_title'),
            description: context.tr('feature_1_desc'),
            icon: Icons.calendar_month_rounded,
          ),
          buildFeatureCard(
            context: context,
            title: context.tr('feature_2_title'),
            description: context.tr('feature_2_desc'),
            icon: Icons.video_call_rounded,
          ),

          // 📹 ميزة مكالمات الفيديو المستقرة عبر WebRTC و Firestore
          buildFeatureCard(
            context: context,
            title: context.tr('feature_webrtc_call_title'),
            description: context.tr('feature_webrtc_call_desc'),
            icon: Icons.missed_video_call_rounded,
          ),

          buildFeatureCard(
            context: context,
            title: context.tr('feature_chat_draft_title'),
            description: context.tr('feature_chat_draft_desc'),
            icon: Icons.edit_note_rounded,
          ),

          buildFeatureCard(
            context: context,
            title: context.tr('feature_analytics_dashboard_title'),
            description: context.tr('feature_analytics_dashboard_desc'),
            icon: Icons.analytics_rounded,
          ),

          buildFeatureCard(
            context: context,
            title: context.tr('feature_3_title'),
            description: context.tr('feature_3_desc'),
            icon: Icons.star_rate_rounded,
          ),
          buildFeatureCard(
            context: context,
            title: context.tr('feature_4_title'),
            description: context.tr('feature_4_desc'),
            icon: Icons.emoji_events_rounded,
          ),
          buildFeatureCard(
            context: context,
            title: context.tr('feature_5_title'),
            description: context.tr('feature_5_desc'),
            icon: Icons.chat_bubble_rounded,
          ),
          buildFeatureCard(
            context: context,
            title: context.tr('feature_6_title'),
            description: context.tr('feature_6_desc'),
            icon: Icons.cloud_done_rounded,
          ),
          buildFeatureCard(
            context: context,
            title: context.tr('feature_7_title'),
            description: context.tr('feature_7_desc'),
            icon: Icons.notifications_active_rounded,
          ),

          SizedBox(height: 24.h),

          buildSectionTitle(context, context.tr('support_and_privacy')),
          SizedBox(height: 12.h),

          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? theme.cardColor : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDarkMode ? AppColors.whiteColor.withOpacity(0.08) : AppColors.greyColor.withOpacity(0.2),
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                _buildLinkRow(context: context, title: context.tr('privacy_policy'), icon: Icons.privacy_tip_outlined),
                const Divider(height: 1),
                _buildLinkRow(context: context, title: context.tr('help_center'), icon: Icons.help_outline_rounded),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '${context.tr('version')} 1.0.0',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 11.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildLinkRow({required BuildContext context, required String title, required IconData icon}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? AppColors.whiteColor.withOpacity(0.54) : AppColors.darkGreyColor, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDarkMode ? AppColors.whiteColor.withOpacity(0.38) : AppColors.greyColor.withOpacity(0.4),
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
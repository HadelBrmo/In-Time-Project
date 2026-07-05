import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';

import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../widgets/buildFeatureCard.dart';
import '../widgets/buildSectionTitle.dart';

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
            title: Text(
              'حول التطبيق',

            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'منصتكم الرائدة لتبادل الخدمات واستثمار الوقت في مجتمع تفاعلي ذكي.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            buildSectionTitle(context, 'مميزات تجعل تجربتك فريدة'),
            SizedBox(height: 12.h),

            buildFeatureCard(
              context: context,
              title: 'إدارة وحجز المواعيد',
              description: 'نظم جدولك بسهولة، استعرض مواعيدك القادمة، واحصل على تنبيهات دقيقة لضمان عدم ضياع أي فرصة.',
              icon: Icons.calendar_month_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'التواصل المرئي المباشر',
              description: 'قدم استشاراتك أو تلقَّ خدماتك وجهاً لوجه عبر اتصال مرئي وصوتي عالي الجودة وبكل خصوصية.',
              icon: Icons.video_call_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'نظام التقييم والمصداقية',
              description: 'مجتمعنا مبني على الثقة؛ يمكنك تقييم جودة الخدمات لضمان أفضل تجربة لجميع المستخدمين.',
              icon: Icons.star_rate_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'لوحة الشرف والمكافآت',
              description: 'تميزك لا يضيع سدى؛ اجمع النقاط والأوسمة ونافس للوصول إلى لوحة الصدارة للمستخدمين الأكثر إنتاجية.',
              icon: Icons.emoji_events_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'محادثات فورية ذكية',
              description: 'تواصل مع الآخرين بسرعة وسهولة لمناقشة تفاصيل الخدمات في بيئة آمنة ومنظمة.',
              icon: Icons.chat_bubble_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'العمل في أصعب الظروف',
              description: 'تصفح خدماتك ومحادثاتك في أي وقت، حتى عند انقطاع الاتصال بالإنترنت، بفضل نظام المزامنة التلقائي.',
              icon: Icons.cloud_done_rounded,
            ),
            buildFeatureCard(
              context: context,
              title: 'دعم عالمي وتنبيهات ذكية',
              description: 'واجهة تدعم اللغتين العربية والإنجليزية، مع نظام إشعارات ذكي يبقيك على اطلاع دائم بكل جديد.',
              icon: Icons.notifications_active_rounded,
            ),

            SizedBox(height: 24.h),

            buildSectionTitle(context, 'الدعم والخصوصية'),
            SizedBox(height: 12.h),

            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? theme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey[200]!,
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  _buildLinkRow(context: context, title: 'سياسة الخصوصية وشروط الاستخدام', icon: Icons.privacy_tip_outlined),
                  const Divider(height: 1),
                  _buildLinkRow(context: context, title: 'مركز المساعدة والدعم الفني', icon: Icons.help_outline_rounded),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'الإصدار 1.0.0',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
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
            Icon(icon, color: isDarkMode ? Colors.white54 : Colors.grey[600], size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDarkMode ? Colors.white38 : Colors.grey[400],
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
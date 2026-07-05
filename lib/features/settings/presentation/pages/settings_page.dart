import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';

import '../../../../core/widgets/customAppBar.dart';
import '../widgets/buildInfoRow.dart';
import '../widgets/buildLanguageOption.dart';
import '../widgets/buildSectionCard.dart';
import '../widgets/buildSecurityActionRow.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'ar';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2EC5B6);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: CustomAppBar(
            title: Text(
              'الإعدادات',

            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            buildSectionCard(
              context: context,
              title: 'اللغة',
              icon: Icons.language_outlined,
              child: Column(
                children: [
                  buildLanguageOption(
                    title: 'العربية',
                    flag: '🇸🇦',
                    isSelected: _selectedLanguage == 'ar',
                    onTap: () => setState(() => _selectedLanguage = 'ar'), context: context,
                  ),
                  const Divider(),
                  buildLanguageOption(
                    title: 'الإنجليزية',
                    flag: '🇬🇧',
                    isSelected: _selectedLanguage == 'en',
                    onTap: () => setState(() => _selectedLanguage = 'en'), context: context,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            buildSectionCard(
              context: context,
              title: 'الإشعارات',
              icon: Icons.notifications_none_outlined,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تشغيل الإشعارات',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Switch(
                    value: _isNotificationsEnabled,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() => _isNotificationsEnabled = value);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            buildSectionCard(
              context: context,
              title: 'الأمان وحماية الحساب',
              icon: Icons.lock_outline_rounded,
              child: Column(
                children: [
                  buildSecurityActionRow(
                    context: context,
                    title: 'تغيير كلمة المرور',
                    subtitle: 'تحديث كلمة المرور الخاصة بك بشكل دوري يحمي حسابك',
                    icon: Icons.key_rounded,
                    onTap: () {
                    },
                  ),

                  Divider(height: 24.h, color: Theme.of(context).dividerColor),

                  buildSecurityActionRow(
                    context: context,
                    title: 'نسيت كلمة المرور؟',
                    subtitle: 'إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                    icon: Icons.lock_reset_rounded,
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 2,
                ),
                onPressed: () {},
                child: Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




}
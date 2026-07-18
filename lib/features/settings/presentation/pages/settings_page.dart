import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../localization/presentation/bloc/locale_bloc.dart';
import '../../../localization/presentation/bloc/locale_event.dart';
import '../../../localization/presentation/bloc/locale_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        final currentLang = localeState.locale.languageCode;

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
                  context.tr('settings'),
                  style: theme.textTheme.titleSmall,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          body: ResponsiveLayout(
            mobileBody: _buildSettingsContent(context, theme, currentLang),
            tabletBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildSettingsContent(context, theme, currentLang),
              ),
            ),
            desktopBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: _buildSettingsContent(context, theme, currentLang),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsContent(BuildContext context, ThemeData theme, String currentLang) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          buildSectionCard(
            context: context,
            title: context.tr('language'),
            icon: Icons.language_outlined,
            child: Column(
              children: [
                buildLanguageOption(
                  title: context.tr('arabic'),
                  flag: '🇸🇦',
                  isSelected: currentLang == 'ar',
                  onTap: () {
                    context.read<LocaleBloc>().add(const ChangeLocaleEvent('ar'));
                  },
                  context: context,
                ),
                const Divider(),
                buildLanguageOption(
                  title: context.tr('english'),
                  flag: '🇬🇧',
                  isSelected: currentLang == 'en',
                  onTap: () {
                    context.read<LocaleBloc>().add(const ChangeLocaleEvent('en'));
                  },
                  context: context,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          buildSectionCard(
            context: context,
            title: context.tr('notifications'),
            icon: Icons.notifications_none_outlined,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('enable_notifications'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _isNotificationsEnabled,
                  activeColor: AppColors.primaryColor,
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
            title: context.tr('security_and_protection'),
            icon: Icons.lock_outline_rounded,
            child: Column(
              children: [
                buildSecurityActionRow(
                  context: context,
                  title: context.tr('change_password'),
                  subtitle: context.tr('change_password_subtitle'),
                  icon: Icons.key_rounded,
                  onTap: () {},
                ),
                Divider(height: 24.h, color: theme.dividerColor),
                buildSecurityActionRow(
                  context: context,
                  title: context.tr('forgot_password'),
                  subtitle: context.tr('forgot_password_subtitle'),
                  icon: Icons.lock_reset_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: CustomButton(
              text: context.tr('save'),
              fontSize: 18,
              color: AppColors.primaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
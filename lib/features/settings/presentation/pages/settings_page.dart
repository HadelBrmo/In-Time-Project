import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../localization/presentation/bloc/locale_bloc.dart';
import '../../../localization/presentation/bloc/locale_event.dart';
import '../../../localization/presentation/bloc/locale_state.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_event.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../../../theme/presentation/bloc/theme_bloc.dart';
import '../../../theme/presentation/bloc/theme_event.dart';
import '../../../theme/presentation/bloc/theme_state.dart';
import '../widgets/buildLanguageOption.dart';
import '../widgets/buildSectionCard.dart';
import '../widgets/buildSecurityActionRow.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isDark = context.read<ThemeBloc>().state.themeMode == ThemeMode.dark;
      if (isDark) {
        _controller.value = 0.0;
      } else {
        _controller.value = 0.5;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('enable_notifications'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: state.isNotificationsEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        context.read<NotificationsBloc>().add(ToggleNotificationsEvent(value));
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          buildSectionCard(
            context: context,
            title: context.tr('animations'),
            icon: Icons.auto_awesome_motion_outlined,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('enable_animations'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: state.animationsEnabled,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleAnimationsEvent(value));
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          buildSectionCard(
            context: context,
            title: context.tr('appearance'),
            icon: Icons.palette_outlined,
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final isDarkMode = themeState.themeMode == ThemeMode.dark;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isDarkMode ? context.tr('dark_mode') : context.tr('light_mode'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isDarkMode) {
                          _controller.animateTo(0.5, duration: const Duration(milliseconds: 500));
                        } else {
                          _controller.animateTo(0.0, duration: const Duration(milliseconds: 500));
                        }
                        context.read<ThemeBloc>().add(ToggleThemeEvent());
                      },
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, settingsState) {
                          return SizedBox(
                            height: 50.h,
                            width: 80.w,
                            child: Lottie.asset(
                              'assets/animations/dark_mode_animation.json',
                              controller: _controller,
                              animate: settingsState.animationsEnabled,
                              onLoaded: (composition) {
                                _controller.duration = composition.duration;
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
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
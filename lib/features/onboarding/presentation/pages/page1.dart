import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/global_particles_wrapper.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GlobalParticlesWrapper(child: const SizedBox.shrink()),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(media.width * 0.05),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: AppColors.greyColor, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          context.tr('skip'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsImage.onboardingImage1,
                          fit: BoxFit.contain,
                          height: media.isPortrait ? media.height * 0.45 : media.height * 0.5,
                        ),
                        SizedBox(height: media.height * 0.01),
                        Text(
                          context.tr('onboarding_1_title'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: media.isPortrait ? 24 : 22,
                          ),
                        ),
                        SizedBox(height: media.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            context.tr('onboarding_1_desc'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: media.isPortrait ? 20 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
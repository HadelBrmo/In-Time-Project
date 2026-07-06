import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/global_particles_wrapper.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GlobalParticlesWrapper(
        child: SafeArea(
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
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsImage.onboardingImage2,
                        fit: BoxFit.contain,
                        height: media.isPortrait ? media.height * 0.45 : media.height * 0.5,
                      ),
                      Text(
                        context.tr('onboarding_2_title'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: media.isPortrait ? 24 : 22,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: media.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          context.tr('onboarding_2_desc'),
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
      ),
    );
  }
}
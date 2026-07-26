import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/global_particles_wrapper.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color iconAndTextColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;

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
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: iconAndTextColor,
                        size: 18,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsImage.onboardingImage3,
                        fit: BoxFit.contain,
                        height: media.isPortrait ? media.height * 0.45 : media.height * 0.5,
                      ),
                      Text(
                        context.tr('onboarding_3_title'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: media.isPortrait ? 22 : 22,
                          color: iconAndTextColor,
                        ),
                      ),
                      SizedBox(height: media.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          context.tr('onboarding_3_desc'),
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
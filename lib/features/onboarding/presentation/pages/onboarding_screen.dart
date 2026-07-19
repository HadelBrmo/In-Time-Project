import 'package:flutter/material.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/features/onboarding/presentation/pages/page1.dart';
import 'package:in_time/features/onboarding/presentation/pages/page2.dart';
import 'package:in_time/features/onboarding/presentation/pages/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/utils/auth_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  bool onlastPage = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  onlastPage = (index == 2);
                });
              },
              children: const [
                Page1(),
                Page2(),
                Page3(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: media.width * 0.05,
              vertical: media.height * 0.04,
            ),
            child: Column(
              children: [
                CustomButton(
                  text: onlastPage ? context.tr('start_now') : context.tr('next'),
                  onPressed: () {
                    if (onlastPage) {
                      if (AuthUtils.isLoggedIn()) {
                        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.login);
                      }
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  }, 
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: media.height * 0.06),

                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: const WormEffect(
                    activeDotColor: AppColors.primaryColor,
                    dotColor: AppColors.greyColor,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
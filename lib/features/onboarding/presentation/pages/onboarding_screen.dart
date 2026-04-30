import 'package:flutter/material.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/features/onboarding/presentation/pages/page1.dart';
import 'package:in_time/features/onboarding/presentation/pages/page2.dart';
import 'package:in_time/features/onboarding/presentation/pages/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/mediaQuery.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
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
              vertical: media.height * 0.07,
            ),
            child: Column(
              children: [
                CustomButton(
                  text: onlastPage ? "ابدأ الآن" : "التالي",
                  onPressed: () {
                    if (onlastPage) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                SizedBox(height: media.height * 0.08),

                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: AppColors.primaryColor,
                    dotColor: Colors.grey,
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
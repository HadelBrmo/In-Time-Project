import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../onboarding/presentation/pages/onboarding_screen.dart';
import '../../../onboarding/presentation/pages/page1.dart';
import '../../../onboarding/presentation/pages/page2.dart';
import '../../../onboarding/presentation/pages/page3.dart';

void navigateToBoarding(BuildContext context) {
  Future.delayed(const Duration(seconds: 4), () {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),

      );
    }
  });
}
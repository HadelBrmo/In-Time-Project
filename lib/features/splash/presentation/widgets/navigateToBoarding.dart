import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../onboarding/presentation/pages/onboarding_screen.dart';

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
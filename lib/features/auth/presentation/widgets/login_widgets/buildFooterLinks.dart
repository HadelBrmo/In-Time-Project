import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../pages/sign up/sign up_page_01.dart';

Widget buildFooterLinks(MediaQueryHelper media, BuildContext context) {
  return Column(
    children: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpPage1(),
            ),
          );
        },
        child: Text.rich(
          TextSpan(
            text: "ليس لديك حساب؟ ",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
            children: [
              TextSpan(
                text: "سجل الآن",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: media.height * 0.01),
      TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/homeScreen');
        },
        child: const Text(
          "الدخول كزائر",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );
}

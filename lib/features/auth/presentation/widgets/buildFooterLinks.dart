import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';

Widget buildFooterLinks(MediaQueryHelper media) {
  return Column(
    children: [
      TextButton(
        onPressed: () {
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
        },
        child: Text(
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
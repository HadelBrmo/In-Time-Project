import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../pages/sign up/sign up_page_01.dart';

Widget buildFooterLinks(MediaQueryHelper media, BuildContext context) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

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
            text: context.tr('no_account'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDarkMode ? AppColors.whiteColor.withOpacity(0.7) : AppColors.darkGreyColor,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: context.tr('register_now'),
                style: theme.textTheme.titleMedium?.copyWith(
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
        child: Text(
          context.tr('login_as_guest'),
          style: theme.textTheme.titleMedium?.copyWith(
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

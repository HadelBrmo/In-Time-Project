import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_localizations.dart';

class CustomErrorView extends StatelessWidget {
  final String message;
  final int? statusCode;
  final VoidCallback onRetry;

  const CustomErrorView({
    super.key,
    required this.message,
    this.statusCode,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    String guidanceMessage = context.tr('error_check_inputs');
    if (statusCode == 401) guidanceMessage = context.tr('error_session_expired');
    if (statusCode == 500) guidanceMessage = context.tr('error_server');
    if (statusCode == 404) guidanceMessage = context.tr('error_not_found');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/complaints/submit_complaint.png',
              height: media.height * 0.28,
            ),
            SizedBox(height: media.height * 0.03),

            Text(
              statusCode != null ? "${context.tr('error_code')} ($statusCode)" : context.tr('error_occured'),
              style: theme.textTheme.titleSmall?.copyWith(fontSize: 20, color: Colors.redAccent),
            ),
            SizedBox(height: media.height * 0.015),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 16, color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: media.height * 0.01),

            Text(
              guidanceMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, color: AppColors.greyColor),
            ),
            SizedBox(height: media.height * 0.04),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.whiteColor),
              label: Text(context.tr('retry'), style: theme.textTheme.titleMedium?.copyWith(color: AppColors.whiteColor, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final String complaintId;
  final String status;
  final String complaintType;
  final String complaintDescription;

  const ComplaintDetailsPage({
    super.key,
    required this.complaintId,
    required this.status,
    required this.complaintType,
    required this.complaintDescription,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final containerBgColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;
    final containerBorderColor = isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);
    final titleTextColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final valueTextColor = isDarkMode ? Colors.white70 : AppColors.greyColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: Text(
            context.tr('complaint_details'),
            style: theme.textTheme.titleSmall,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: containerBgColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: containerBorderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.tr('complaint')} $complaintId',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.2),
                    thickness: 1,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailItem(
                    context: context,
                    title: context.tr('current_status'),
                    value: status,
                    titleColor: titleTextColor,
                    valueColor: valueTextColor,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailItem(
                    context: context,
                    title: context.tr('complaint_type'),
                    value: complaintType,
                    titleColor: titleTextColor,
                    valueColor: valueTextColor,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailItem(
                    context: context,
                    title: context.tr('complaint_description'),
                    value: complaintDescription,
                    titleColor: titleTextColor,
                    valueColor: valueTextColor,
                  ),
                  const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     // Text(
                  //     //   context.tr('evidence'),
                  //     //   style: theme.textTheme.titleMedium?.copyWith(
                  //     //     fontWeight: FontWeight.bold,
                  //     //     color: titleTextColor,
                  //     //   ),
                  //     // ),
                  //     const SizedBox(width: 12),
                  //     const Icon(
                  //       Icons.picture_as_pdf_outlined,
                  //       color: AppColors.primaryColor,
                  //       size: 24,
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       context.tr('complaint_file_pdf'),
                  //       style: theme.textTheme.titleMedium?.copyWith(
                  //         color: valueTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: CustomButton(
                      text: context.tr('done'),
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 350.ms).scale(begin: const Offset(0.98, 0.98)),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required String title,
    required String value,
    required Color titleColor,
    required Color valueColor,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: titleColor.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: valueColor,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
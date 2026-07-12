import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/status_badge.dart';
import 'complaint_details_page.dart';

class ComplaintStatusListPage extends StatelessWidget {
  const ComplaintStatusListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final itemBgColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;
    final itemBorderColor = isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);
    final textDarkColor = isDarkMode ? Colors.white70 : AppColors.greyColor;

    final complaints = [
      {
        'id': '123',
        'date': '2026-02-02',
        'time': '11:11 م',
        'update': 'منذ يومين',
        'status': context.tr('done_status'),
        'type': ComplaintStatusType.done,
      },
      {
        'id': '124',
        'date': '2026-02-12',
        'time': '9:38 ص',
        'update': 'منذ أسبوع',
        'status': context.tr('processing_status'),
        'type': ComplaintStatusType.processing,
      },
      {
        'id': '125',
        'date': '2026-02-01',
        'time': '15:55 م',
        'update': 'منذ ساعتين',
        'status': context.tr('rejected_status'),
        'type': ComplaintStatusType.rejected,
      },
      {
        'id': '126',
        'date': '2026-01-15',
        'time': '6:30 ص',
        'update': 'منذ ساعتين',
        'status': context.tr('done_status'),
        'type': ComplaintStatusType.done,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: Text(
            context.tr('complaint_status'),
            style: theme.textTheme.titleSmall,
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemCount: complaints.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final complaint = complaints[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: itemBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: itemBorderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusBadgeWidget(
                        title: complaint['status'] as String,
                        type: complaint['type'] as ComplaintStatusType,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${context.tr('complaint')} ${complaint['id']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 22,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${context.tr('date_with_colon')} ${complaint['date']}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textDarkColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${context.tr('time_with_colon')} ${complaint['time']}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textDarkColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${context.tr('last_update_with_colon')} ${complaint['update']}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textDarkColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      text: context.tr('view_details'),
                      fontSize: 15,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ComplaintDetailsPage(
                              complaintId: complaint['id'] as String,
                              status: complaint['status'] as String,
                              complaintType: context.tr('technical_problem'),
                              complaintDescription: 'عدم الصدق بالمعلومات',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 350.ms, delay: (index * 80).ms).slideY(begin: 0.1, end: 0);
          },
        ),
      ),
    );
  }
}
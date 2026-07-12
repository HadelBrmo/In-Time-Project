import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../injection_container.dart';
import '../bloc/complaint_bloc.dart';
import '../bloc/complaint_event.dart';
import '../bloc/complaint_state.dart';
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

    // تم حذف Directionality من هنا لأن التطبيق يدعم العربية تلقائياً
    return BlocProvider(
      create: (context) => sl<ComplaintBloc>()..add(FetchMyComplaintsEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: Text(
            context.tr('complaint_status'),
            style: theme.textTheme.titleSmall,
          ),
        ),
        body: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            if (state is MyComplaintsLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is ComplaintError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            } else if (state is MyComplaintsLoaded) {
              final complaints = state.complaints;

              if (complaints.isEmpty) {
                return Center(child: Text('لا توجد شكاوى سابقة', style: theme.textTheme.titleMedium));
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                itemCount: complaints.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  
                  final String id = complaint['id'].toString();
                  final String reason = complaint['reason'] ?? 'غير محدد';
                  final String desc = complaint['description'] ?? '';
                  final DateTime createdAt = DateTime.parse(complaint['created_at']).toLocal();
                  
                  final String dateStr = DateFormat('yyyy-MM-dd').format(createdAt);
                  final String timeStr = DateFormat('hh:mm a').format(createdAt);
                  
                  ComplaintStatusType type;
                  String statusText;
                  if (complaint['status'] == 'resolved') {
                    type = ComplaintStatusType.done;
                    statusText = 'تم الحل';
                  } else if (complaint['status'] == 'rejected') {
                    type = ComplaintStatusType.rejected;
                    statusText = 'مرفوض';
                  } else {
                    type = ComplaintStatusType.processing;
                    statusText = 'قيد الانتظار';
                  }

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
    // ✅ 1. قسم رقم الشكوى والتاريخ (أصبح هو الأول ليظهر مكان الحالة)
    Column(
      crossAxisAlignment: CrossAxisAlignment.start, // جعل النص يبدأ من اليمين
      children: [
        Text(
          'شكوى $id',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 22,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'التاريخ: $dateStr',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textDarkColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'الوقت: $timeStr',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textDarkColor,
          ),
        ),
      ],
    ),
    // ✅ 2. حالة الشكوى (قيد الانتظار) أصبحت في الطرف الآخر
    StatusBadgeWidget(
      title: statusText,
      type: type,
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
                                    complaintId: id,
                                    status: statusText,
                                    complaintType: reason,
                                    complaintDescription: desc,
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
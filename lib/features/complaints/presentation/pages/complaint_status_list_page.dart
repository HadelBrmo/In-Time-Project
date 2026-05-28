import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import '../widgets/status_badge.dart';
import 'complaint_details_page.dart';

class ComplaintStatusListPage extends StatelessWidget {
  const ComplaintStatusListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final complaints = [
      {
        'id': '123',
        'date': '2026-02-02',
        'time': '11:11 م',
        'update': 'منذ يومين',
        'status': 'منجزة',
        'type': ComplaintStatusType.done,
      },
      {
        'id': '124',
        'date': '2026-02-12',
        'time': '9:38 ص',
        'update': 'منذ أسبوع',
        'status': 'قيد المعالجة',
        'type': ComplaintStatusType.processing,
      },
      {
        'id': '125',
        'date': '2026-02-01',
        'time': '15:55 م',
        'update': 'منذ ساعتين',
        'status': 'مرفوضة',
        'type': ComplaintStatusType.rejected,
      },
      {
        'id': '126',
        'date': '2026-01-15',
        'time': '6:30 ص',
        'update': 'منذ ساعتين',
        'status': 'منجزة',
        'type': ComplaintStatusType.done,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar:  CustomAppBar(
        title: const Text( 'حالة الشكوى' , style: TextStyle(color: AppColors.whiteColor , fontSize: 26 , fontWeight: FontWeight.bold),),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        itemCount: complaints.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 28),
        itemBuilder: (context, index) {
          final complaint = complaints[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
               color: AppColors.greyColor , width: 1.5
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadgeWidget(
                      title: complaint['status'] as String,
                      type: complaint['type']
                          as ComplaintStatusType,
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          'شكوى ${complaint['id']}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'التاريخ : ${complaint['date']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'الوقت : ${complaint['time']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'آخر تحديث : ${complaint['update']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    text: 'عرض التفاصيل',
                    color: AppColors.primaryColor,
                    onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ComplaintDetailsPage(
        complaintId: complaint['id'] as String,
        status: complaint['status'] as String,
        complaintType: 'خدمة سيئة',
        complaintDescription:
            'عدم الصدق بالمعلومات',
      ),
    ),
  );
},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
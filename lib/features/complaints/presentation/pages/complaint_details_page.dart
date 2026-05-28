import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/core/widgets/custom_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      appBar: CustomAppBar(
        title: const Text(
          'حالة الشكوى',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 35,
          ),

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 28,
            ),

            decoration: BoxDecoration(
              color: AppColors.whiteColor,

              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: AppColors.greyColor , width: 1.5),

              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              children: [

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'شكوى $complaintId',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Divider(
                  color: AppColors.greyColor,
                  thickness: 1,
                ),

                const SizedBox(height: 42),

                detailItem(
                  title: 'الحالة الحالية',
                  value: status,
                ),

                const SizedBox(height: 26),

                detailItem(
                  title: 'نوع الشكوى',
                  value: complaintType,
                ),

                const SizedBox(height: 26),

                detailItem(
                  title: 'وصف الشكوى',
                  value: complaintDescription,
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Icon(
                      Icons.picture_as_pdf_outlined,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      'ملف',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                     ': الإثبات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 55),

                SizedBox(
                  width: 190,
                  height: 58,

                  child: CustomButton(
                    text: 'تم',
                    color: AppColors.primaryColor,
                    fontSize: 25,
                    
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailItem({
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.greyColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          ': $title',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
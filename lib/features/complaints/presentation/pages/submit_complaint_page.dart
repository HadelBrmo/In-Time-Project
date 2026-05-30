import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/buildLabel.dart';
import 'package:in_time/core/widgets/customTextFormField.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import '../widgets/complaint_success_dialog.dart';
import '../widgets/complaint_type_dropdown.dart';
import '../widgets/evidence_upload_widget.dart';
import 'complaint_status_list_page.dart';

class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  State<SubmitComplaintPage> createState() =>
      _SubmitComplaintPageState();
}

class _SubmitComplaintPageState
    extends State<SubmitComplaintPage> {

  final TextEditingController
      descriptionController =
      TextEditingController();

  String? selectedComplaintType;

  @override
  void dispose() {

    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.whiteColor,

      appBar: CustomAppBar(

        title: const Text(
          'تقديم شكوى',

          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          Padding(

            padding:
                const EdgeInsets.only(
              right: 8.0,
            ),

            child: IconButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                        const ComplaintStatusListPage(),
                  ),
                );
              },

              icon: const Icon(
                Icons.receipt,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 8,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.end,

          children: [

            Center(

              child: Image.asset(

                'assets/images/complaints/submit_complaint.png',

                height: 220,

                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 2),

            Center(

              child: Text(

                'يرجى تعبئة المعلومات أدناه لتقديم شكواك وسنرد عليك في أقرب وقت',

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 16,

                  color: AppColors.greyColor,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            buildLabel(
              'نوع الشكوى',
            ),

            const SizedBox(height: 12),

            ComplaintTypeDropdown(

              selectedType:
                  selectedComplaintType,

              onChanged: (value) {

                setState(() {

                  selectedComplaintType =
                      value;
                });
              },
            ),

            const SizedBox(height: 18),

            buildLabel(
              'وصف الشكوى',
            ),

            const SizedBox(height: 12),

            Container(

              decoration: BoxDecoration(

                borderRadius:
                    BorderRadius.circular(20),

                border: Border.all(

                  color: AppColors.greyColor
                      .withOpacity(0.2),

                  width: 1.5,
                ),
              ),

              child: CustomTextFormField(

                controller:
                    descriptionController,

                hintText:
                    'اكتب وصف الشكوى.....',

                maxLines: 6,
              ),
            ),

            const SizedBox(height: 18),

            buildLabel(
              'ارفع صورة أو ملف',
            ),

            const SizedBox(height: 12),

            const EvidenceUploadWidget(),

            const SizedBox(height: 28),

            Center(

              child: SizedBox(

                width: 220,
                height: 65,

                child: CustomButton(

                  text: 'إرسال',

                  fontSize: 20,

                  color:
                      AppColors.primaryColor,

                  onPressed: () {

                    ComplaintSuccessDialog
                        .show(context);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
    }
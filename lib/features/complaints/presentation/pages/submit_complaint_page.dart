import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart'; 

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/buildLabel.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customTextFormField.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection_container.dart';
import '../../data/models/complaint_request.dart';
import '../bloc/complaint_bloc.dart';
import '../bloc/complaint_event.dart';
import '../bloc/complaint_state.dart';
import '../widgets/complaint_success_dialog.dart';
import '../widgets/complaint_type_dropdown.dart';
import '../widgets/evidence_upload_widget.dart';
import 'complaint_status_list_page.dart';


class SubmitComplaintPage extends StatefulWidget {
  final int servingId;
  final int accusedUserId;

  const SubmitComplaintPage({
    super.key,
    required this.servingId,
    required this.accusedUserId,
  });

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedComplaintType;
  int? servingId;
  String? attachmentPath;

  @override
  void initState() {
    super.initState();
    servingId = widget.servingId;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (selectedComplaintType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('please_select_complaint_type')), backgroundColor: Colors.redAccent),
        );
        return;
      }

      final request = ComplaintRequest(
        servingId: servingId ?? 1,
        accusedUserId: widget.accusedUserId,
        reason: selectedComplaintType!,
        description: descriptionController.text.trim(),
        attachmentPath: attachmentPath,
      );

      context.read<ComplaintBloc>().add(SubmitComplaintEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final hintTextColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;
    final containerBorderColor = isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);

    return BlocProvider(
      create: (context) => sl<ComplaintBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: Text(
              context.tr('submit_complaint'),
              style: theme.textTheme.titleSmall,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComplaintStatusListPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded, color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
          body: BlocConsumer<ComplaintBloc, ComplaintState>(
            listener: (context, state) {
              if (state is ComplaintSuccess) {
                ComplaintSuccessDialog.show(context);
                descriptionController.clear();
                setState(() {
                  selectedComplaintType = null;
                  attachmentPath = null;
                });
              } else if (state is ComplaintError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${context.tr('error')}: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/complaints/submit_complaint.png',
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.report_problem_rounded, size: 90, color: isDarkMode ? Colors.white30 : AppColors.greyColor);
                          },
                        ),
                      ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          context.tr('complaint_instruction'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: hintTextColor,
                            height: 1.5,
                          ),
                        ),
                      ).animate().fade(delay: 100.ms),
                      const SizedBox(height: 28),

                      buildLabel(context, context.tr('complaint_type')),
                      const SizedBox(height: 8),
                      ComplaintTypeDropdown(

                        selectedType: selectedComplaintType,
                        onChanged: (value) {
                          setState(() {
                            selectedComplaintType = value;
                            if (servingId == null || servingId == 1) {
                              if (value == context.tr('technical_problem')) servingId = 1;
                              if (value == context.tr('service_delay')) servingId = 2;
                              if (value == context.tr('harassment')) servingId = 3;
                              if (value == context.tr('others')) servingId = 4;
                            }
                          });
                        },
                      ).animate().fade(delay: 150.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),

                      buildLabel(context, context.tr('complaint_description')),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: containerBorderColor,
                            width: 1,
                          ),
                        ),
                        child: CustomTextFormField(
                          controller: descriptionController,
                          hintText: context.tr('complaint_description_hint'),
                          maxLines: 5,
                          validator: (v) => (v == null || v.trim().isEmpty) ? context.tr('please_enter_complaint_description') : null,
                        ),
                      ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 40),

                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: state is ComplaintSubmitting
                              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                              : CustomButton(
                            text: context.tr('send_complaint'),
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            onPressed: () => _submitComplaint(context),
                          ),
                        ),
                      ).animate().fade(delay: 250.ms).scale(begin: const Offset(0.98, 0.98)),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/build_label.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../injection_container.dart';
import '../../data/models/complaint_request.dart';
import '../bloc/complaint_bloc.dart';
import '../bloc/complaint_event.dart';
import '../bloc/complaint_state.dart';
import '../widgets/complaint_success_dialog.dart';
import '../widgets/complaint_type_dropdown.dart';

class SubmitComplaintPage extends StatelessWidget {
  final int servingId;
  final int accusedUserId;

  const SubmitComplaintPage({
    super.key,
    required this.servingId,
    required this.accusedUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ComplaintBloc>(),
      child: SubmitComplaintView(
        servingId: servingId,
        accusedUserId: accusedUserId,
      ),
    );
  }
}

class SubmitComplaintView extends StatefulWidget {
  final int servingId;
  final int accusedUserId;

  const SubmitComplaintView({
    super.key,
    required this.servingId,
    required this.accusedUserId,
  });

  @override
  State<SubmitComplaintView> createState() => _SubmitComplaintViewState();
}

class _SubmitComplaintViewState extends State<SubmitComplaintView> {
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedComplaintType;
  List<String> selectedFiles = [];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles(FileType type) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.paths.whereType<String>());
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  void _submitComplaint(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (selectedComplaintType == null) {
        SnackBarUtils.showError(context, context.tr('please_select_complaint_type'));
        return;
      }

      String reasonKey = 'others';
      if (selectedComplaintType == context.tr('technical_problem')) {
        reasonKey = 'technical_problem';
      } else if (selectedComplaintType == context.tr('service_delay')) {
        reasonKey = 'service_not_delivered';
      } else if (selectedComplaintType == context.tr('harassment')) {
        reasonKey = 'harassment';
      }

      final request = ComplaintRequest(
        servingId: widget.servingId,
        accusedUserId: widget.accusedUserId,
        reason: reasonKey,
        description: descriptionController.text.trim(),
        documentPaths: selectedFiles,
      );

      context.read<ComplaintBloc>().add(SubmitComplaintEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final hintTextColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;
    final containerBorderColor =
        isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          context.tr('submit_complaint'),
          style: theme.textTheme.titleSmall,
        ),
      ),
      body: BlocConsumer<ComplaintBloc, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintSuccess) {
            ComplaintSuccessDialog.show(context);
            descriptionController.clear();
            setState(() {
              selectedComplaintType = null;
              selectedFiles = [];
            });
          } else if (state is ComplaintError) {
            SnackBarUtils.showError(context, '${context.tr('error')}: ${state.message}');
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobileBody: _buildForm(theme, isDarkMode, hintTextColor, containerBorderColor, state),
            tabletBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildForm(theme, isDarkMode, hintTextColor, containerBorderColor, state),
              ),
            ),
            desktopBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: _buildForm(theme, isDarkMode, hintTextColor, containerBorderColor, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(ThemeData theme, bool isDarkMode, Color hintTextColor, Color containerBorderColor, ComplaintState state) {
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
                  return Icon(
                    Icons.report_problem_rounded,
                    size: 90,
                    color: isDarkMode ? Colors.white30 : AppColors.greyColor,
                  );
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
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.tr('please_enter_complaint_description')
                    : null,
              ),
            ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            buildLabel(context, context.tr('upload_image_or_file')),
            const SizedBox(height: 8),
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: AppColors.greyColor.withOpacity(0.5),
                strokeWidth: 1,
                dashPattern: const [6, 3],
                radius: const Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildUploadButton(
                      icon: Icons.description_outlined,
                      label: context.tr('file'),
                      onTap: () => _pickFiles(FileType.any),
                    ),
                    _buildUploadButton(
                      icon: Icons.image_outlined,
                      label: context.tr('image'),
                      onTap: () => _pickFiles(FileType.image),
                    ),
                  ],
                ),
              ),
            ).animate().fade(delay: 250.ms).slideY(begin: 0.1, end: 0),
            if (selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedFiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final path = entry.value;
                  final fileName = path.split('/').last;
                  return Chip(
                    label: Text(
                      fileName,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onDeleted: () => _removeFile(index),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.primaryColor.withOpacity(0.2)),
                    ),
                  );
                }).toList(),
              ),
            ],
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
            ).animate().fade(delay: 300.ms).scale(begin: const Offset(0.98, 0.98)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

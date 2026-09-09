import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/build_label.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection_container.dart';
import '../bloc/complaint_bloc.dart';
import '../bloc/complaint_event.dart';
import '../bloc/complaint_state.dart';

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
    return BlocProvider(
      create: (_) => sl<ComplaintBloc>(),
      child: _ComplaintDetailsView(
        complaintId: complaintId,
        status: status,
        complaintType: complaintType,
        complaintDescription: complaintDescription,
      ),
    );
  }
}

class _ComplaintDetailsView extends StatefulWidget {
  final String complaintId;
  final String status;
  final String complaintType;
  final String complaintDescription;

  const _ComplaintDetailsView({
    required this.complaintId,
    required this.status,
    required this.complaintType,
    required this.complaintDescription,
  });

  @override
  State<_ComplaintDetailsView> createState() => _ComplaintDetailsViewState();
}

class _ComplaintDetailsViewState extends State<_ComplaintDetailsView> {
  final List<String> _selectedFiles = [];

  Future<void> _pickFiles(FileType type) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.whereType<String>());
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _uploadEvidence(BuildContext context) {
    if (_selectedFiles.isEmpty) {
      SnackBarUtils.showWarning(context, context.tr('upload_image_or_file'));
      return;
    }

    final complaintId = int.tryParse(widget.complaintId);
    if (complaintId == null) {
      SnackBarUtils.showError(context, context.tr('error'));
      return;
    }

    context.read<ComplaintBloc>().add(
      UploadComplaintDocumentsEvent(complaintId, _selectedFiles),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final containerBgColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;
    final containerBorderColor = isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);
    final titleTextColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final valueTextColor = isDarkMode ? Colors.white70 : AppColors.greyColor;

    return BlocConsumer<ComplaintBloc, ComplaintState>(
      listener: (context, state) {
        if (state is ComplaintUploadSuccess) {
          SnackBarUtils.showSuccess(context, context.tr('saved'));
          setState(() {
            _selectedFiles.clear();
          });
        } else if (state is ComplaintError) {
          SnackBarUtils.showError(context, '${context.tr('error')}: ${state.message}');
        }
      },
      builder: (context, state) {
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
                        '${context.tr('complaint')} ${widget.complaintId}',
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
                        value: widget.status,
                        titleColor: titleTextColor,
                        valueColor: valueTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildDetailItem(
                        context: context,
                        title: context.tr('complaint_type'),
                        value: widget.complaintType,
                        titleColor: titleTextColor,
                        valueColor: valueTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildDetailItem(
                        context: context,
                        title: context.tr('complaint_description'),
                        value: widget.complaintDescription,
                        titleColor: titleTextColor,
                        valueColor: valueTextColor,
                      ),
                      const SizedBox(height: 20),
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
                      if (_selectedFiles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedFiles.asMap().entries.map((entry) {
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
                          child: state is ComplaintUploading
                              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                              : CustomButton(
                                  text: context.tr('send_complaint'),
                                  fontSize: 16,
                                  color: AppColors.primaryColor,
                                  onPressed: () => _uploadEvidence(context),
                                ),
                        ),
                      ).animate().fade(delay: 300.ms).scale(begin: const Offset(0.98, 0.98)),
                      const SizedBox(height: 24),
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
      },
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
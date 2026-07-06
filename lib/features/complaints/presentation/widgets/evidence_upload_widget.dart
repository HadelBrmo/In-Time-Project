import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';

class EvidenceUploadWidget extends StatefulWidget {
  final Function(String?) onFileSelected;
  final String? initialPath;

  const EvidenceUploadWidget({
    super.key,
    required this.onFileSelected,
    this.initialPath,
  });

  @override
  State<EvidenceUploadWidget> createState() => _EvidenceUploadWidgetState();
}

class _EvidenceUploadWidgetState extends State<EvidenceUploadWidget> {
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.initialPath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedPath = image.path;
      });
      widget.onFileSelected(image.path);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPath = result.files.single.path;
      });
      widget.onFileSelected(result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildUploadButton(
                  onTap: _pickImage,
                  icon: Icons.image_outlined,
                  label: 'صورة',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildUploadButton(
                  onTap: _pickFile,
                  icon: Icons.folder_open_outlined,
                  label: 'ملف',
                ),
              ),
            ],
          ),
        ),
        if (_selectedPath != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedPath!.split('/').last,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _selectedPath = null;
                    });
                    widget.onFileSelected(null);
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.whiteColor,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

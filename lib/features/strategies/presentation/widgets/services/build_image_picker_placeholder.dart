import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';

Widget buildImagePickerPlaceholder({
  required MediaQueryHelper media,
  required void Function(XFile?) onImagePicked,
  required BuildContext context,
  XFile? selectedImage,
}) {
  final ImagePicker picker = ImagePicker();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    height: media.height * 0.18,
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(media.width * 0.05),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[200]!,
      ),
      image: selectedImage != null
          ? DecorationImage(image: FileImage(File(selectedImage.path)), fit: BoxFit.cover)
          : null,
    ),
    child: selectedImage == null ? IconButton(
      onPressed: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        onImagePicked(image);
      },
      icon: Icon(
        Icons.camera_alt,
        size: media.width * 0.12,
        color: isDarkMode ? AppColors.secondaryColor.withOpacity(0.6) : AppColors.primaryColor.withOpacity(0.5),
      ),
    ) : InkWell(
      onTap: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        onImagePicked(image);
      },
      child: Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.all(media.width * 0.025),
        child: CircleAvatar(
          backgroundColor: isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor,
          radius: media.width * 0.04,
          child: Icon(Icons.edit, size: media.width * 0.04, color: Colors.white),
        ),
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class ComplaintTypeDropdown extends StatelessWidget {
  final String? selectedType;
  final Function(String?) onChanged;

  const ComplaintTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    final dropdownFillColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final dropdownBorderColor = isDarkMode ? AppColors.greyColor.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.2);
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final hintTextColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;

    final complaintTypes = [
      context.tr('technical_problem'),
      context.tr('service_delay'),
      context.tr('harassment'),
      context.tr('others'),
    ];

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedType,
      dropdownColor: dropdownFillColor,
      style: theme.textTheme.titleMedium?.copyWith(color: textColor),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primaryColor,
        size: media.width * 0.07,
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: context.tr('please_select_complaint_type'),
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: hintTextColor,
          fontSize: 14,
        ),
        filled: true,
        fillColor: dropdownFillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: media.width * 0.05,
          vertical: media.height * 0.02,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: dropdownBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: dropdownBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      items: complaintTypes.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              item,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium?.copyWith(color: textColor),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
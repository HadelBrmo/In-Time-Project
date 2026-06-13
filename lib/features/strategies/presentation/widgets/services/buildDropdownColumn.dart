import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/constants/mediaQuery.dart';

Widget buildDropdownColumn({
  required BuildContext context,
  required String label,
  required String hint,
  required String? selectedValue,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  final media = MediaQueryHelper(context);
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildLabel(label),
      Container(
        height: media.height * 0.07,
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.025),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF252525) : Colors.transparent,
          borderRadius: BorderRadius.circular(media.width * 0.04),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[300]!,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            dropdownColor: isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: media.width * 0.03,
                color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor,
              size: media.width * 0.06,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: media.width * 0.035,
                    color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final Color backgroundColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
  final Color borderColor = isDarkMode ? const Color(0xFF3A3A3A) : AppColors.greyColor.withOpacity(0.3);
  final Color dropdownBgColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
  final Color textColor = isDarkMode ? Colors.white : AppColors.blackColor;
  final Color hintColor = isDarkMode ? Colors.white70 : AppColors.darkGreyColor;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildLabel(context, label),
      SizedBox(height: 8.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.04, vertical: 2.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            dropdownColor: dropdownBgColor,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 14.sp,
                color: hintColor,
                fontFamily: 'Arial',
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textColor,
                    fontFamily: 'Arial',
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
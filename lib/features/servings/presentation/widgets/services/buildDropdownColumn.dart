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

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildLabel(context,label),
      Container(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.025),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.blackColor : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(media.width * 0.04),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF3A3A3A) : Colors.white24,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            dropdownColor: isDarkMode ? AppColors.blackColor : const Color(0xFF2C2C2C),
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
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
                    color: Colors.white,
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
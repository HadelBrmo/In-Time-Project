import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buildLabel.dart';
import '../../../../core/constants/mediaQuery.dart';

Widget buildDropdownColumn({
  required BuildContext context,
  required String label,
  required String hint,
  required String? selectedValue,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  final media = MediaQueryHelper(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildLabel(label),
      Container(
        height: media.height * 0.07,
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(media.width * 0.04),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: Text(hint, style: TextStyle(fontSize: media.width * 0.03)),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor, size: media.width * 0.06),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: media.width * 0.035)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}

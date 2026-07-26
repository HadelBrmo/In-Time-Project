import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/constants/media_query.dart';

Widget buildTimeRangePicker({
  required BuildContext context,
  TextEditingController? startTimeController,
  TextEditingController? endTimeController,
}) {
  final media = MediaQueryHelper(context);
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDarkMode ? Colors.white : Colors.black87;

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: isDarkMode
              ? ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: AppColors.blackColor,
              onSurface: Colors.white,
            ),
          )
              : ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      controller.text = formattedTime;
    }
  }

  return Row(
    children: [
      Expanded(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              titleMedium: TextStyle(color: textColor),
            ),
          ),
          child: CustomTextFormField(
            controller: startTimeController,
            hintText: "من ساعة",
            readOnly: true,
            onTap: () => _selectTime(context, startTimeController!),
            suffixIcon: Icon(
                Icons.access_time,
                size: media.width * 0.05,
                color: AppColors.primaryColor
            ),
          ),
        ),
      ),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.015),
        child: Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: media.width * 0.04, color: textColor)),
      ),

      Expanded(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              titleMedium: TextStyle(color: textColor),
            ),
          ),
          child: CustomTextFormField(
            controller: endTimeController,
            hintText: "إلى ساعة",
            readOnly: true,
            onTap: () => _selectTime(context, endTimeController!),
            suffixIcon: Icon(
                Icons.access_time,
                size: media.width * 0.05,
                color: AppColors.primaryColor
            ),
          ),
        ),
      ),
    ],
  );
}
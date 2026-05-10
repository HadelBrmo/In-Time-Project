import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/customTextFormField.dart';
import '../../../../core/constants/mediaQuery.dart';

Widget buildTimeRangePicker({
  required BuildContext context,
  TextEditingController? startTimeController,
  TextEditingController? endTimeController,
}) {
  final media = MediaQueryHelper(context);

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  return Row(
    children: [
      Expanded(
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

      Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.015),
        child: Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: media.width * 0.04)),
      ),

      Expanded(
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
    ],
  );
}

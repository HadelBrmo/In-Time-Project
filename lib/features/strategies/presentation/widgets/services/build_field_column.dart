import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../auth/presentation/widgets/signup_widgets/customDatePickerField.dart';
import 'build_days_picker.dart';
import 'build_time_range_picker.dart';

Widget buildFieldColumn(String label, String hint, {
  required BuildContext context,
  List<String> userSelectedDays = const [],
  bool isDate = false,
  bool isMultiDay = false,
  bool isTimeRange = false,
  IconData? icon,
  TextInputType? keyboardType,
  void Function(List<String>)? onDaysChanged,
  void Function(String)? onDateSelected,
  TextEditingController? controller,
  TextEditingController? startTimeController,
  TextEditingController? endTimeController,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!isDate) buildLabel(label),

      if (isMultiDay)
        MultiSelectDaysDropdown(
          selectedDays: List.from(userSelectedDays),
          onChanged: (newDays) {
            if (onDaysChanged != null) {
              onDaysChanged(newDays);
            }
          },
        )
      else if (isTimeRange)
        buildTimeRangePicker(
          context: context,
          startTimeController: startTimeController,
          endTimeController: endTimeController,
        )
      else if (isDate)
          CustomDatePickerField(
            controller: controller ?? TextEditingController(),
            label: label,
            hintText: hint,
            onDateSelected: onDateSelected ?? (val) {},
          )
        else
          CustomTextFormField(

            keyboardType: keyboardType ?? TextInputType.text,
            controller: controller,
            hintText: hint,
            validator: validator,
            suffixIcon: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
          ),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../../core/constants/app_colors.dart';

class CustomDatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Function(String) onDateSelected;

  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.onDateSelected,
  });

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'SA'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: const TextTheme(
              labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          child: Localizations.override(
            context: context,
            locale: const Locale('ar', 'SA'),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controller.text = formattedDate;
      onDateSelected(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: AppColors.blackColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.calendar_month, color: AppColors.primaryColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          onTap: () => selectDate(context),
        ),
      ],
    );
  }
}
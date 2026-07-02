import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/SignUpBloc/sign up_bloc.dart';
import '../../bloc/SignUpBloc/sign up_event.dart';

Widget buildGenderDropdown(BuildContext context, String selectedGender) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey.withValues(alpha: 0.3)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedGender,
        dropdownColor: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
        ),
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: isDarkMode ? Colors.white70 : Colors.grey,
          size: 30,
        ),
        items: ["ذكر", "أنثى"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            context.read<SignUpBloc>().add(UpdateGenderEvent(newValue));
          }
        },
      ),
    ),
  );
}
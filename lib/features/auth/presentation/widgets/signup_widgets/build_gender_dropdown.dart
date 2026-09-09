import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../bloc/sign_up_bloc/sign_up_bloc.dart';
import '../../bloc/sign_up_bloc/sign_up_event.dart';

Widget buildGenderDropdown(BuildContext context, String selectedGender) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDarkMode ? AppColors.whiteColor.withOpacity(0.24) : AppColors.greyColor.withOpacity(0.3)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedGender,
        dropdownColor: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
          fontSize: 16,
        ),
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: isDarkMode ? AppColors.whiteColor.withOpacity(0.7) : AppColors.greyColor,
          size: 30,
        ),
        items: [
          DropdownMenuItem(value: "ذكر", child: Text(context.tr('male'))),
          DropdownMenuItem(value: "أنثى", child: Text(context.tr('female'))),
        ],
        onChanged: (newValue) {
          if (newValue != null) {
            context.read<SignUpBloc>().add(UpdateGenderEvent(newValue));
          }
        },
      ),
    ),
  );
}
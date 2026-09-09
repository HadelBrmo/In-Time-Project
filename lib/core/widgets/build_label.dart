import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

Widget buildLabel(BuildContext context, String text) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
    child: Text(
      text,
      style: TextStyle(
        color: isDarkMode ? Colors.white : AppColors.blackColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
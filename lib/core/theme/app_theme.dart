import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(color: AppColors.primaryColor),
    colorScheme: ColorScheme.light(background: AppColors.whiteColor),
    primaryColor: AppColors.primaryColor,
    buttonTheme: ButtonThemeData(buttonColor: AppColors.primaryColor),
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'ArchivoBlack',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Arial',
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Arial',
        fontSize: 15,
        color: AppColors.whiteColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Arial',
        fontSize: 15,
        color: AppColors.blackColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.blackColor,
        fontFamily: 'ArchivoBlack',
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Arial',
        color: Colors.grey,
        fontSize: 15,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Arial',
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(color: AppColors.primaryColor),
    colorScheme: ColorScheme.dark(background: AppColors.blackColor),
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'ArchivoBlack',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Arial',
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Arial',
        fontSize: 15,
        color: AppColors.secondaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Arial',
        fontSize: 15,
        color: AppColors.whiteColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.whiteColor,
        fontFamily: 'ArchivoBlack',
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Arial',
        color: AppColors.secondaryColor,
        fontSize: 15,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Arial',
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/mediaQuery.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width,
    this.height,
    this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? media.width * 0.48,
      height: height ?? 50,
      child: isOutlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: fontSize ?? 16,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: fontSize ?? 16,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
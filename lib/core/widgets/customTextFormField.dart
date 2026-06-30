import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  int? maxLines;
  final TextInputType keyboardType;
  final Color? fillColor;

  CustomTextFormField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.fillColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final defaultFillColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final defaultBorderColor = isDarkMode ? AppColors.greyColor : AppColors.greyColor.withOpacity(0.3);
    final defaultTextColor = isDarkMode ? Colors.white : AppColors.blackColor;
    final defaultHintColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        validator: widget.validator,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        style: TextStyle(fontSize: 15, color: defaultTextColor),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: defaultHintColor, fontSize: 14),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: AppColors.primaryColor)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.greyColor,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          )
              : widget.suffixIcon,
          filled: true,
          fillColor: widget.fillColor ?? defaultFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: defaultBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: defaultBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
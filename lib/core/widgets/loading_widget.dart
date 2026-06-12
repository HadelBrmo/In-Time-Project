import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final defaultSize = mediaQuery.size.width * 0.08;

    return Center(
      child: SizedBox(
        width: size ?? defaultSize,
        height: size ?? defaultSize,
        child: CircularProgressIndicator(
          strokeWidth: 3.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
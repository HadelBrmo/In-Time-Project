import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';

Widget buildHeader(MediaQueryHelper media, BuildContext context) {
  final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
  final bool isTablet = media.width > 600;

  return Container(
    height: isLandscape ? media.height * 0.35 : media.height * 0.45,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: isLandscape ? media.height * 0.02 : media.height * 0.08,
        ),
        child: Text(
          "تسجيل الدخول",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: isLandscape ? 22 : (isTablet ? 35 : 28),
            color: Colors.white,
            fontFamily: 'ArchivoBlack',
          ),
        ),
      ),
    ),
  );
}
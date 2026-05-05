import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';

Widget buildHeaderForSignUp(MediaQueryHelper media, BuildContext context) {
  return Stack(
    alignment: Alignment.topCenter,
    clipBehavior: Clip.none,
    children: [
      Container(
        height: media.height * 0.40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: const Column(
          children: [
            SizedBox(height: 50),
            Text(
              "إنشاء الحساب",
              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "المعلومات الشخصية",
              style: TextStyle(color: Colors.white70, fontSize: 17),
            ),
          ],
        ),
      ),

      Positioned.directional(
        textDirection: Directionality.of(context),
        start: 10,
        top: 40,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ],
  );
}
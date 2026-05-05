import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_colors.dart';

Widget buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
    child: Text(text,
        style: TextStyle(color: AppColors.blackColor, fontSize: 15, fontWeight: FontWeight.bold)
    ),
  );
}
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../core/constants/mediaQuery.dart';

Widget buildActionButton(String text, Color bgColor, Color textColor, MediaQueryHelper media) {
  return Container(
    height: media.height * 0.065,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(media.width * 0.04),
    ),
    child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: media.width * 0.04)),
  );
}
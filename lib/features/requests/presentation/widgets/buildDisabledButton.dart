import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/mediaQuery.dart';

Widget buildDisabledButton(MediaQueryHelper media, bool isDarkMode, String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: media.width * 0.04, vertical: media.height * 0.008),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
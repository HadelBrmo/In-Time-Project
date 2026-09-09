import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildSectionTitle(BuildContext context, String title) {
  return Align(
    alignment: Alignment.centerRight,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2EC5B6),
      ),
    ),
  );
}

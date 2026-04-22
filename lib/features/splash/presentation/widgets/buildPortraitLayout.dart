import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPortraitLayout(){
  return Column(
    mainAxisAlignment: .center,
    children: [
      Image.asset(
        'assets/icons/logo.png',
        width: 300.w,
        height: 300.h,
      ),

    ],
  );
}
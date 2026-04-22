import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLandscapeLayout(){
return Row(
  mainAxisAlignment: .center,
  children: [
    Image.asset(
      'assets/icons/logo.png',
      width: 250.w,
      height: 250.h,
    ),
  ],
);
}
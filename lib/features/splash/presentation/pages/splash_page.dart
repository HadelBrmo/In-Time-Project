import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/buildLandscapeLayout.dart';
import '../widgets/buildPortraitLayout.dart';
import '../widgets/navigateToBoarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    navigateToBoarding(context);
  }
  @override
  Widget build(BuildContext context) {
    final orientation=MediaQuery.of(context).orientation;
    final isLandscape=orientation==Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:Center(
          child: isLandscape
              ? buildLandscapeLayout()
              : buildPortraitLayout(),
        ) ,
      ),
    );
  }
}
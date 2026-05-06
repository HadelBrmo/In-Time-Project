import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/customAppBar.dart';

import '../../../../core/widgets/customDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(title: Text("All Services",
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 22,
          color: AppColors.whiteColor
        )
      )),
      drawer: const CustomDrawer(),
      body: Center(child: Text("محتوى الصفحة الرئيسية")),
    ) ;
  }
}

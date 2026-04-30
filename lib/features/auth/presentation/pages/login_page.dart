import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../widgets/LoginForm.dart';
import '../widgets/buildFooterLinks.dart';
import '../widgets/buildHeader.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildHeader(media, context),
            Container(
              margin: EdgeInsets.only
                (top: media.height * 0.22,
                  right: media.width * 0.03,
                  left: media.width * 0.03),
              decoration: const BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(60))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.08,
                    ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Center(child: Image.asset('assets/icons/Logo_01.png',
                          height: media.height * 0.18)),

                      const LoginForm(),
                      SizedBox(height: media.height * 0.02),
                      buildFooterLinks(media),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
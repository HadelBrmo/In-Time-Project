import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';

import '../../../../../injection_container.dart';
import '../../bloc/loginBloc/login_bloc.dart';
import '../../widgets/login_widgets/LoginForm.dart';
import '../../widgets/login_widgets/buildFooterLinks.dart';
import '../../widgets/login_widgets/buildHeader.dart';

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
              margin: EdgeInsets.only(
                top: media.height * 0.22,
                right: media.width * 0.03,
                left: media.width * 0.03,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(60)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.08,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/Logo_01.png',
                          height: media.height * 0.18,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => sl<LoginBloc>(),
                        child: const LoginForm(),
                      ),

                      SizedBox(height: media.height * 0.02),
                      buildFooterLinks(media, context),
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
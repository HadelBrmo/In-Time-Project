import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';

import '../../../../../core/widgets/global_particles_wrapper.dart';
import '../../../../../core/widgets/responsive_layout.dart';
import '../../../../../injection_container.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../widgets/login_widgets/login_form.dart';
import '../../widgets/login_widgets/build_footer_links.dart';
import '../../widgets/login_widgets/build_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GlobalParticlesWrapper(
      child: Scaffold(
        body: ResponsiveLayout(
          mobileBody: _buildMobileLogin(media, isDarkMode, context),
          tabletBody: _buildDesktopLogin(media, isDarkMode, context),
          desktopBody: _buildDesktopLogin(media, isDarkMode, context),
        ),
      ),
    );
  }

  Widget _buildMobileLogin(MediaQueryHelper media, bool isDarkMode, BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          buildHeader(media, context),
          Container(
            margin: EdgeInsets.only(
              top: media.height * 0.22,
              right: media.width * 0.03,
              left: media.width * 0.03,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.blackColor : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(60)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.08),
              child: _buildLoginForm(media, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLogin(MediaQueryHelper media, bool isDarkMode, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.blackColor : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              )
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: _buildLoginForm(media, context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(MediaQueryHelper media, BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 20),
          buildFooterLinks(media, context),
        ],
      ),
    );
  }
}
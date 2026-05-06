import 'package:flutter/material.dart';
import 'package:in_time/features/auth/presentation/pages/sign%20up/sign%20up_page_03.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/sign up/sign up_page_01.dart';
import '../../features/auth/presentation/pages/sign up/sign up_page_02.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../constants/app_colors.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String initialRoute = splash;
  static const String signUpPage1 = '/signUpPage1';
  static const String signUpPage2 = '/signUpPage2';
  static const String signUpPage3 = '/signUpPage3';
  static const String chatListScreen = '/chatListScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) =>  SplashPage(),
          settings: settings,
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);

      case signUpPage1:
        return MaterialPageRoute(builder: (_) => const SignUpPage1(), settings: settings);

      case signUpPage2:
        return MaterialPageRoute(builder: (_) => const SignUpPage2(), settings: settings);

      case signUpPage3:
        return MaterialPageRoute(builder: (_) => const SignUpPage3(), settings: settings);

      case chatListScreen:
        return MaterialPageRoute(builder: (_) =>  ChatListScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
          settings: settings,
        );
    }
  }
}
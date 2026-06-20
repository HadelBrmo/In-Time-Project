import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/features/auth/presentation/pages/sign%20up/sign%20up_page_03.dart';
import 'package:in_time/features/home/presentation/pages/home_screen.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/sign up/sign up_page_01.dart';
import '../../features/auth/presentation/pages/sign up/sign up_page_02.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/home/domain/entities/service_entity.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/home/presentation/pages/serviceDetailsPage.dart';
import '../../features/requests/domain/entity/request_entity.dart';
import '../../features/requests/presentation/bloc/request_bloc.dart';
import '../../features/requests/presentation/pages/my_requests_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/strategies/presentation/pages/services/barter_strategy.dart';
import '../../features/strategies/presentation/pages/services/paid_strategy.dart';
import '../../injection_container.dart';
import '../constants/app_colors.dart';
import '../widgets/customBottomNavBar.dart';
import '../../features/complaints/presentation/pages/submit_complaint_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String initialRoute = splash;
  static const String signUpPage1 = '/signUpPage1';
  static const String signUpPage2 = '/signUpPage2';
  static const String signUpPage3 = '/signUpPage3';
  static const String chatListScreen = '/chatListScreen';
  static const String homeScreen = '/homeScreen';
  static const String paidStrategyPage = '/paidStrategyPage';
  static const String submitComplaintPage = '/submitComplaintPage';
  static const String myRequestsPage = '/myRequestsPage';
  static const String serviceDetailsPage = '/serviceDetailsPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashPage(),
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
        return MaterialPageRoute(builder: (_) => ChatListScreen(), settings: settings);

      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeBloc>()..add(const FetchHomeServingsEvent(isRefresh: true)),
            child: const CustomBottomNavBar(),
          ),
          settings: settings,
        );

      case paidStrategyPage:
        return MaterialPageRoute(builder: (_) => PaidServicePage(), settings: settings);

      case submitComplaintPage:
        return MaterialPageRoute(
          builder: (_) => const SubmitComplaintPage(),
          settings: settings,
        );

      case myRequestsPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<RequestsBloc>(),
            child: const MyRequestsPage(),
          ),
          settings: settings,
        );

      case serviceDetailsPage:
        final args = settings.arguments;
        int serviceId = 0;
        bool isFromRequests = false;

        if (args is int) {
          serviceId = args;
        } else if (args is ServicingEntity) {
          serviceId = args.id ?? 0;
        } else if (args is RequestServingEntity) {
          serviceId = args.id ?? 0;
          isFromRequests = true;
        } else if (args is Map<String, dynamic>) {
          serviceId = args['serviceId'] ?? 0;
          isFromRequests = args['isFromRequests'] ?? false;
        }

        return MaterialPageRoute(
          builder: (_) => ServiceDetailsPage(
            serviceId: serviceId,
            isFromRequests: isFromRequests,
          ),
          settings: settings,
        );

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
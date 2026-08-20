import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/features/home/presentation/pages/home_screen.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page_01.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page_02.dart';
import '../../features/auth/presentation/pages/sign_up/sign_up_page_03.dart';
import '../../features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../../features/chat/presentation/pages/chats/chats_page.dart';
import '../../features/chat/presentation/pages/chats/chat_room_page.dart';
import '../../features/chat/presentation/pages/groups/create_group_page.dart';
import '../../features/chat/presentation/pages/video_call/video_call_page.dart';
import '../../features/complaints/presentation/bloc/complaint_bloc.dart';
import '../../features/home/presentation/pages/service_details_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/servings/domain/entity/service_entity.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/requests/presentation/bloc/received_requests/received_requests_bloc.dart';
import '../../features/requests/domain/entity/request_entity.dart';
import '../../features/requests/presentation/bloc/request_bloc.dart';
import '../../features/requests/presentation/pages/my_requests_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/rewards/presentation/pages/my_rewards_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/servings/presentation/pages/services/paid_strategy.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../injection_container.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
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
  static const String chatRoomPage = '/chatRoomPage';
  static const String createGroupScreen = '/createGroupScreen';
  static const String profilePage = '/profilePage';
  static const String videoCallPage = '/videoCallPage';
  static const String notificationsPage = '/notificationsPage';
  static const String myRewardsPage = '/myRewardsPage';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(page: SplashPage(), settings: settings);

      case onboarding:
        return _buildPageRoute(page: const OnboardingScreen(), settings: settings);

      case login:
        return _buildPageRoute(page: const LoginScreen(), settings: settings);

      case signUpPage1:
        return _buildPageRoute(page: const SignUpPage1(), settings: settings);

      case signUpPage2:
        return _buildPageRoute(page: const SignUpPage2(), settings: settings);

      case signUpPage3:
        return _buildPageRoute(page: const SignUpPage3(), settings: settings);

      case createGroupScreen:
        return _buildPageRoute(page: const CreateGroupPage(), settings: settings);

      case chatListScreen:
        return _buildPageRoute(page: const ChatsPage(), settings: settings);

      case chatRoomPage:
        final args = settings.arguments as Map<String, dynamic>?;
        final chatId = args?['chatId'] as int? ?? 0;
        final chatTitle = args?['chatTitle'] as String? ?? "محادثة";
        final isGroup = args?['isGroup'] as bool? ?? false;

        return _buildPageRoute(
          page: ChatRoomPage(chatId: chatId, chatTitle: chatTitle, isGroup: isGroup),
          settings: settings,
        );

      case homeScreen:
        return _buildPageRoute(
          page: BlocProvider(
            create: (context) => sl<HomeBloc>()..add(const FetchHomeServingsEvent(isRefresh: true)),
            child: const CustomBottomNavBar(),
          ),
          settings: settings,
        );

      case paidStrategyPage:
        return _buildPageRoute(page: PaidServicePage(), settings: settings);

      case submitComplaintPage:
        final args = settings.arguments as Map<String, dynamic>?;
        final servingId = args?['servingId'] as int? ?? 0;
        final accusedUserId = args?['accusedUserId'] as int? ?? 0;

        return _buildPageRoute(
          page: BlocProvider(
            create: (context) => sl<ComplaintBloc>(),
            child: SubmitComplaintPage(servingId: servingId, accusedUserId: accusedUserId),
          ),
          settings: settings,
        );

      case myRequestsPage:
        return _buildPageRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RequestsBloc>()),
              BlocProvider(create: (context) => sl<ReceivedRequestsBloc>()),
            ],
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
        } else if (args is ServiceEntity) {
          serviceId = args.id ?? 0;
        } else if (args is Map<String, dynamic>) {
          serviceId = args['serviceId'] ?? 0;
          isFromRequests = args['isFromRequests'] ?? false;
        }

        return _buildPageRoute(
          page: ServiceDetailsPage(serviceId: serviceId, isFromRequests: isFromRequests),
          settings: settings,
        );

      case profilePage:
        return _buildPageRoute(page: const ProfilePage(), settings: settings);

      case videoCallPage:
        final args = settings.arguments as Map<String, dynamic>?;
        final chatId = args?['chatId'] as int? ?? 0;
        final chatTitle = args?['chatTitle'] as String? ?? "مكالمة فيديو";

        return _buildPageRoute(
          page: VideoCallPage(chatId: chatId, chatTitle: chatTitle),
          settings: settings,
        );

      case notificationsPage:
        return _buildPageRoute(
          page: const NotificationsPage(),
          settings: settings,
        );

      case myRewardsPage:
        return _buildPageRoute(
          page: const MyRewardsPage(),
          settings: settings,
        );

      default:
        return _buildPageRoute(
          page: const Scaffold(body: Center(child: Text('Page not found'))),
          settings: settings,
        );
    }
  }

  static Route<dynamic> _buildPageRoute({required Widget page, required RouteSettings settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {


        final scaleAnimation = Tween<double>(
          begin: 0.85,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.bounceIn,
        ));


        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ));

        // دمج الحركتين معاً لخروج ناعم ومنبثق من الشاشة
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
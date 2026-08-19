import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/localization/app_localizations.dart';
import 'firebase_options.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/global_particles_wrapper.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/chat/presentation/bloc/chat_bloc/bloc_event.dart';
import 'features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'features/localization/presentation/bloc/locale_bloc.dart';
import 'features/localization/presentation/bloc/locale_event.dart';
import 'features/localization/presentation/bloc/locale_state.dart';
import 'features/theme/presentation/bloc/theme_bloc.dart';
import 'features/theme/presentation/bloc/theme_event.dart';
import 'features/theme/presentation/bloc/theme_state.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'package:in_time/features/auth/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:in_time/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:in_time/features/servings/presentation/bloc/service/services_bloc.dart';
import 'package:in_time/features/servings/presentation/bloc/saved_services/saved_services_bloc.dart';
import 'package:in_time/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:in_time/features/wallet/presentation/bloc/wallet_event.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_event.dart';
import 'core/services/pusher_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/notification_service.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await di.init();

  await LocalNotificationService.initialize();
  await FCMService.initialize();

  final authLocal = sl<AuthLocalDataSource>();
  final String? token = await authLocal.getToken();

  if (token != null && token.isNotEmpty) {
    sl<PusherService>().init();
  }

  final String initialRoute = (token != null && token.isNotEmpty) ? '/home' : '/';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ServicesBloc>(
              create: (context) => sl<ServicesBloc>(),
            ),
            BlocProvider<LoginBloc>(
              create: (context) => sl<LoginBloc>(),
            ),
            BlocProvider<SignUpBloc>(
              create: (context) => sl<SignUpBloc>(),
            ),
            BlocProvider<ChatBloc>(
              create: (context) => sl<ChatBloc>(),
            ),
            BlocProvider<LocaleBloc>(
              create: (context) => sl<LocaleBloc>()..add(const GetSavedLocaleEvent()),
            ),
            BlocProvider<ThemeBloc>(
              create: (context) => sl<ThemeBloc>()..add(GetSavedThemeEvent()),
            ),
            BlocProvider<SavedServicesBloc>(
              create: (context) => sl<SavedServicesBloc>()..add(GetSavedServicesEvent()),
            ),
            BlocProvider<NotificationsBloc>(
              create: (context) => sl<NotificationsBloc>()
                ..add(GetMyNotificationsEvent())
                ..add(GetUnreadNotificationsCountEvent()),
            ),
            BlocProvider<SettingsBloc>(
              create: (context) => sl<SettingsBloc>()..add(GetSavedSettingsEvent()),
            ),
            BlocProvider<WalletBloc>(
              create: (context) => sl<WalletBloc>()..add(GetMyWalletsEvent()),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<LocaleBloc, LocaleState>(
                builder: (context, localeState) {
                  return MaterialApp(
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: localeState.locale,
                    supportedLocales: const [
                      Locale('ar', 'SA'),
                      Locale('en', 'US'),
                    ],
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightMode,
                    darkTheme: AppTheme.darkMode,
                    themeMode: themeState.themeMode,
                    navigatorKey: AppRoutes.navigatorKey,
                    builder: (context, child) {
                      final isDarkMode = themeState.themeMode == ThemeMode.dark;
                      final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

                      return Scaffold(
                        backgroundColor: backgroundColor,
                        body: Stack(
                          children: [
                            const Positioned.fill(
                              child: GlobalParticlesWrapper(
                                child: SizedBox.shrink(),
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                scaffoldBackgroundColor: Colors.transparent,
                              ),
                              child: child ?? const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                    initialRoute: '/',
                    onGenerateRoute: AppRoutes.generateRoute,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
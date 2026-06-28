import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/global_particles_wrapper.dart';
import 'features/chat/presentation/bloc/chatBloc/blocEvent.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';
import 'package:in_time/features/auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
import 'package:in_time/features/auth/presentation/bloc/loginBloc/login_bloc.dart';
import 'features/strategies_services/presentation/bloc/service/services_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
            BlocProvider<ChatBloc>(
              create: (context) => sl<ChatBloc>()..add(LoadChatsEvent()),
            ),
            BlocProvider<ServicesBloc>(
              create: (context) => sl<ServicesBloc>(),
            ),
            BlocProvider<LoginBloc>(
              create: (context) => sl<LoginBloc>(),
            ),
            BlocProvider<SignUpBloc>(
              create: (context) => sl<SignUpBloc>(),
            ),
          ],
          child:  MaterialApp(
            localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ],
        supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
        themeMode: ThemeMode.system,

        builder: (context, child) {
        final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

        final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

        return Scaffold(
        backgroundColor: backgroundColor,
        body: GlobalParticlesWrapper(
        child: child ?? const SizedBox.shrink(),
        ),
        );
        },
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
        ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/presentation/bloc/chatBloc/blocEvent.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';
import 'package:in_time/features/auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
import 'package:in_time/features/auth/presentation/bloc/loginBloc/login_bloc.dart';
import 'package:in_time/features/strategies/presentation/bloc/services_bloc.dart';
import 'package:in_time/features/strategies/presentation/bloc/services_event.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
 // await Hive.initFlutter();
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
          child: MaterialApp(
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
            initialRoute: '/',
            onGenerateRoute: AppRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
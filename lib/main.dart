import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/data/datasources/chatRemoteDataSource.dart';
import 'features/chat/data/repository/chatRepositoryImpl.dart';
import 'features/chat/domain/usecases/deleteChatUseCase.dart';
import 'features/chat/domain/usecases/getChatsUseCase.dart';
import 'features/chat/domain/usecases/searchChatsUseCase.dart';
import 'features/chat/presentation/bloc/chatBloc/blocEvent.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';

void main() {
  final remoteDataSource = ChatRemoteDataSourceImpl();

  final chatRepository = ChatRepositoryImpl(remoteDataSource: remoteDataSource);

  final getChatsUseCase = GetChatsUseCase(chatRepository);
  final deleteChatUseCase = DeleteChatUseCase(chatRepository);
  final searchChatsUseCase = SearchChatsUseCase(chatRepository);

  runApp(MyApp(
    getChatsUseCase: getChatsUseCase,
    deleteChatUseCase: deleteChatUseCase,
    searchChatsUseCase: searchChatsUseCase,
  ));
}

class MyApp extends StatefulWidget {
  final GetChatsUseCase getChatsUseCase;
  final DeleteChatUseCase deleteChatUseCase;
  final SearchChatsUseCase searchChatsUseCase;

  const MyApp({
    super.key,
    required this.getChatsUseCase,
    required this.deleteChatUseCase,
    required this.searchChatsUseCase,
  });

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
              create: (context) => ChatBloc(
                getChatsUseCase: widget.getChatsUseCase,
                deleteChatUseCase: widget.deleteChatUseCase,
                searchChatsUseCase: widget.searchChatsUseCase,
              )..add(LoadChatsEvent()),
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
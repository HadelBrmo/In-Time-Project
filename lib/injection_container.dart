import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Chat Features
import 'core/constants/app_strings.dart';
import 'features/auth/domain/usecases/sendOtpUseCase.dart';
import 'features/auth/presentation/bloc/loginBloc/login_bloc.dart';
import 'features/auth/presentation/bloc/otpBloc/otp_bloc.dart';
import 'features/chat/data/datasources/chatRemoteDataSource.dart';
import 'features/chat/data/repository/chatRepositoryImpl.dart';
import 'features/chat/domain/repository/chatRepository.dart';
import 'features/chat/domain/usecases/deleteChatUseCase.dart';
import 'features/chat/domain/usecases/getChatsUseCase.dart';
import 'features/chat/domain/usecases/searchChatsUseCase.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';

// Services/Strategies Features
import 'features/strategies/data/datasources/services_remote_data_source.dart';
import 'features/strategies/data/repository/services_repository_impl.dart';
import 'features/strategies/domain/repository/servicesRepository.dart';
import 'features/strategies/domain/usecases/add_service_usecase.dart';
import 'features/strategies/presentation/bloc/services_bloc.dart';

// Auth Features 👈 (المستوردات الجديدة للـ Login)
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';

// استيراد ملف الثوابت لجلب الـ baseUrl

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== 1. Blocs (Factory) ====================
  sl.registerFactory(() => ChatBloc(
    getChatsUseCase: sl(),
    deleteChatUseCase: sl(),
    searchChatsUseCase: sl(),
  ));
  sl.registerFactory(() => OtpBloc(sendOtpUseCase: sl()));
  sl.registerFactory(() => ServicesBloc(addServiceUseCase: sl()));


  // تسجيل الـ LoginBloc الجديد 🚀
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));

  // ==================== 2. Use Cases (LazySingleton) ====================
  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChatUseCase(sl()));
  sl.registerLazySingleton(() => SearchChatsUseCase(sl()));
  sl.registerLazySingleton(() => AddServiceUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));

  // تسجيل الـ LoginUseCase 🚀
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));

  // ==================== 3. Repositories (LazySingleton) ====================
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(remoteDataSource: sl()));

  // تسجيل الـ AuthRepository 🚀
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // ==================== 4. Data Sources (LazySingleton) ====================
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
  sl.registerLazySingleton<ServicesRemoteDataSource>(() => ServicesRemoteDataSourceImpl(dio: sl()));

  // تسجيل الـ AuthRemoteDataSource 🚀
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));


  // ==================== 5. External Libraries (Dio) ====================
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => Dio(
      BaseOptions(
        baseUrl: ApiStringConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ));
  }
}
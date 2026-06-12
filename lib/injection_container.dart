import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

// Chat Features
import 'core/constants/app_strings.dart';
import 'features/auth/domain/usecases/sendOtpUseCase.dart';
import 'features/auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
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
import 'features/home/data/datasources/home_datasources.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/search_services_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/strategies/data/datasources/services_remote_data_source.dart';
import 'features/strategies/data/repository/services_repository_impl.dart';
import 'features/strategies/domain/repository/servicesRepository.dart';
import 'features/strategies/domain/usecases/add_service_usecase.dart';
import 'features/strategies/domain/usecases/get_payment_units_usecase.dart';
import 'features/strategies/presentation/bloc/services_bloc.dart';
import 'core/network/decorators/logging_interceptor.dart';

// Auth Features 🚀
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // ==================== 1. Blocs (Factory) ====================
  sl.registerFactory(() => ChatBloc(
    getChatsUseCase: sl(),
    deleteChatUseCase: sl(),
    searchChatsUseCase: sl(),
  ));
  sl.registerFactory(() => OtpBloc(sendOtpUseCase: sl()));
  sl.registerFactory(
        () => ServicesBloc(
      addServiceUseCase: sl(),
      getPaymentUnitsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => SignUpBloc(registerUseCase: sl()));
  sl.registerFactory(() => HomeBloc(searchServingsUseCase: sl()));

  // ==================== 2. Use Cases (LazySingleton) ====================
  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChatUseCase(sl()));
  sl.registerLazySingleton(() => SearchChatsUseCase(sl()));
  sl.registerLazySingleton(() => AddServiceUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPaymentUnitsUseCase(sl()));
  sl.registerLazySingleton(() => SearchServingsUseCase(sl()));

  // ==================== 3. Repositories (LazySingleton) ====================
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl()));

  // ==================== 4. Data Sources (LazySingleton) ====================
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
  sl.registerLazySingleton<ServicesRemoteDataSource>(() => ServicesRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: sl()));

  // ==================== 5. External Libraries ====================
  if (!sl.isRegistered<Dio>()) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiStringConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = "18|kOSPXN3msdOPAkLQMrZh4Phr3ys5ZvrdcDolGynj8932f4fd";

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(LoggingInterceptor());

    sl.registerLazySingleton(() => dio);
  }

  if (!sl.isRegistered<ImagePicker>()) {
    sl.registerLazySingleton(() => ImagePicker());
  }
}
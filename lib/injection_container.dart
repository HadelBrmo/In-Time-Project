import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'features/home/data/repositories/home_repository_impl.dart' hide HomeRemoteDataSourceImpl;
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/search_services_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/my_servings/data/datasources/my_servings_remote_data_source.dart';
import 'features/my_servings/data/repository/my_servings_repository_impl.dart';
import 'features/my_servings/domain/repository/my_servings_repository.dart';
import 'features/my_servings/domain/usecases/get_my_servings_usecase.dart';
import 'features/my_servings/domain/usecases/update_serving_usecase.dart';
import 'features/my_servings/presentation/bloc/my_servings_bloc.dart';
import 'features/receivedRequests/data/datasources/received_requests_remote_datasource.dart';
import 'features/receivedRequests/data/repository/received_requests_repository_impl.dart';
import 'features/receivedRequests/domain/repository/received_requests_repository.dart';
import 'features/receivedRequests/domain/usecases/accept_request_usecase.dart';
import 'features/receivedRequests/domain/usecases/get_received_requests_usecase.dart';
import 'features/receivedRequests/domain/usecases/reject_request_usecase.dart';
import 'features/receivedRequests/presentation/bloc/received_requests_bloc.dart';
import 'features/receivedRequests/presentation/bloc/received_requests_event.dart';
import 'features/requests/data/datasource/request_remote_datasource.dart';
import 'features/requests/data/repository/request_repository_impl.dart';
import 'features/requests/domain/repository/request_repository.dart';
import 'features/requests/domain/usecases/create_serving_request_usecase.dart';
import 'features/requests/domain/usecases/delete_request_usecase.dart';
import 'features/requests/domain/usecases/get_my_requests_usecase.dart';
import 'features/requests/presentation/bloc/request_bloc.dart';
import 'core/network/decorators/logging_interceptor.dart';
// Auth Features 🚀
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/strategies_services/data/datasources/comment_remote_data_source.dart';
import 'features/strategies_services/data/datasources/services_remote_data_source.dart';
import 'features/strategies_services/data/repository/comment_repository_impl.dart';
import 'features/strategies_services/data/repository/services_repository_impl.dart';
import 'features/strategies_services/domain/repository/comment_repository.dart';
import 'features/strategies_services/domain/repository/servicesRepository.dart';
import 'features/strategies_services/domain/usecases/comment/add_comment_usecase.dart';
import 'features/strategies_services/domain/usecases/comment/get_comments_usecase.dart';
import 'features/strategies_services/domain/usecases/comment/react_dislike_usecase.dart';
import 'features/strategies_services/domain/usecases/comment/react_like_usecase.dart';
import 'features/strategies_services/domain/usecases/comment/reply_to_comment_usecase.dart';
import 'features/strategies_services/domain/usecases/service/add_service_usecase.dart';
import 'features/strategies_services/domain/usecases/service/get_payment_units_usecase.dart';
import 'features/strategies_services/domain/usecases/service/get_service_details_usecase.dart';
import 'features/strategies_services/presentation/bloc/comment/comment_bloc.dart';
import 'features/strategies_services/presentation/bloc/service/services_bloc.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repository/wallet_repository_impl.dart';
import 'features/wallet/domain/repository/wallet_repository.dart';
import 'features/wallet/domain/usecases/get_my_wallets_usecase.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

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
      getServiceDetailsUseCase: sl(),
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
  sl.registerLazySingleton(() => GetServiceDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SearchServingsUseCase(sl()));

  // ==================== 3. Repositories (LazySingleton) ====================
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
    sharedPreferences: sl(),
  ));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl()));

  // ==================== 4. Data Sources (LazySingleton) ====================
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
  sl.registerLazySingleton<ServicesRemoteDataSource>(() => ServicesRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: sl()));

  // ==================== 5. External Libraries ====================
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
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
          final prefs = sl<SharedPreferences>();
          String? token = prefs.getString('token');


          if (token != null && token.isNotEmpty) {
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


  // ==================== 1. Blocs (Factory) ====================
  sl.registerFactory(() => CommentBloc(
    getCommentsUseCase: sl(),
    addCommentUseCase: sl(),
    replyToCommentUseCase: sl(),
    reactLikeUseCase: sl(),
    reactDislikeUseCase: sl(),
  ));

  // ==================== 2. Use Cases (LazySingleton) ====================
  sl.registerLazySingleton(() => GetCommentsForServingUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentOnServingUseCase(sl()));
  sl.registerLazySingleton(() => ReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => ReactLikeUseCase(sl()));
  sl.registerLazySingleton(() => ReactDislikeUseCase(sl()));

  // ==================== 3. Repositories (LazySingleton) ====================
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(remoteDataSource: sl()));

  // ==================== 4. Data Sources (LazySingleton) ====================
  sl.registerLazySingleton<CommentRemoteDataSource>(() => CommentRemoteDataSourceImpl(dio: sl()));

// تسجيل الـ UseCase
  sl.registerLazySingleton(() => CreateServingRequestUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteRequestUseCase(sl()));

  sl.registerFactory(
        () => RequestsBloc(
      getMyRequestsUseCase: sl(),
      createServingRequestUseCase: sl(),
      deleteRequestUseCase: sl(),
    ),
  );
// 2. Use Cases
  sl.registerLazySingleton(() => GetMyRequestsUseCase(repository: sl()));

// 3. Repository
  sl.registerLazySingleton<RequestRepository>(
        () => RequestRepositoryImpl(remoteDataSource: sl()),
  );

// 4. Data Sources
  sl.registerLazySingleton<RequestRemoteDataSource>(
        () => RequestRemoteDataSourceImpl(dio: sl()),
  );

// Bloc
  sl.registerFactory(() => WalletBloc(getMyWalletsUseCase: sl()));

// Use cases
  sl.registerLazySingleton(() => GetMyWalletsUseCase(sl()));

// Repository
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<WalletRemoteDataSource>(() => WalletRemoteDataSourceImpl(dio: sl()));

// ==================== Feature: Received Requests 🚀 ====================
  // 1. Bloc
  sl.registerFactory(() => ReceivedRequestsBloc(
    getReceivedRequestsUseCase: sl(),
    acceptRequestUseCase: sl(),
    rejectRequestUseCase: sl(),
  ));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetReceivedRequestsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));

  // 3. Repositories
  sl.registerLazySingleton<ReceivedRequestsRepository>(
        () => ReceivedRequestsRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<ReceivedRequestsRemoteDataSource>(
        () => ReceivedRequestsRemoteDataSourceImpl(dio: sl()),
  );
  // ==================== Feature: My Servings 💼 ====================
  // 1. Bloc
  sl.registerFactory(() => MyServingsBloc(
    getMyServingsUseCase: sl(),
    updateServingUseCase: sl(),
  ));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetMyServingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateServingUseCase(sl()));

  // 3. Repositories
  sl.registerLazySingleton<MyServingsRepository>(
        () => MyServingsRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<MyServingsRemoteDataSource>(
        () => MyServingsRemoteDataSourceImpl(sl()),
  );

}

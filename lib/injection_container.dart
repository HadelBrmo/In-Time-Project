import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Chat Features
import 'core/constants/app_strings.dart';
import 'features/auth/domain/usecases/sendOtpUseCase.dart';
import 'features/auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
import 'features/auth/presentation/bloc/loginBloc/login_bloc.dart';
import 'features/auth/presentation/bloc/otpBloc/otp_bloc.dart';
import 'features/chat/data/datasources/chatRemoteDataSource.dart';
import 'features/chat/data/datasources/chat_local_data_source.dart';
import 'features/chat/data/repository/chatRepositoryImpl.dart';
import 'features/chat/domain/repository/chatRepository.dart';
import 'features/chat/domain/usecases/getChatsUseCase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/create_group_chat_usecase.dart';
import 'features/chat/domain/usecases/create_personal_chat_usecase.dart';
import 'features/chat/domain/usecases/mark_as_read_usecase.dart';
import 'features/chat/domain/usecases/mark_as_received_usecase.dart';
import 'features/chat/domain/usecases/get_members_usecase.dart';
import 'features/chat/domain/usecases/add_members_usecase.dart';
import 'features/chat/domain/usecases/remove_member_usecase.dart';
import 'features/chat/domain/usecases/update_group_usecase.dart';
import 'features/chat/domain/usecases/leave_group_usecase.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';

// Services/Strategies Features
import 'features/home/data/datasources/home_datasources.dart';
import 'features/home/data/datasources/home_local_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart' hide HomeRemoteDataSourceImpl;
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_nearby_servings_useCase.dart';
import 'features/home/domain/usecases/search_services_usecase.dart';
import 'features/home/domain/usecases/update_availability_useCase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/localization/data/datasource/locale_local_data_source.dart';
import 'features/localization/presentation/bloc/locale_bloc.dart';
import 'features/servings/domain/usecases/service/get_my_servings_usecase.dart';
import 'features/servings/domain/usecases/service/toggle_serving_status_usecase.dart';
import 'features/servings/domain/usecases/service/update_serving_usecase.dart';
import 'features/servings/presentation/bloc/my_servings/my_servings_bloc.dart';
import 'features/requests/data/datasource/request_remote_datasource.dart';
import 'features/requests/data/repository/request_repository_impl.dart';
import 'features/requests/domain/repository/request_repository.dart';
import 'features/requests/domain/usecases/create_serving_request_usecase.dart';
import 'features/requests/domain/usecases/delete_request_usecase.dart';
import 'features/requests/domain/usecases/get_my_requests_usecase.dart';
import 'features/requests/domain/usecases/accept_request_usecase.dart';
import 'features/requests/domain/usecases/get_received_requests_usecase.dart';
import 'features/requests/domain/usecases/reject_request_usecase.dart';
import 'features/requests/presentation/bloc/received_requests/received_requests_bloc.dart';
import 'features/requests/presentation/bloc/request_bloc.dart';
import 'core/network/decorators/logging_interceptor.dart';
// Auth Features 🚀
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';

// Servings Feature 🛠️
import 'features/servings/data/datasources/comment_remote_data_source.dart';
import 'features/servings/data/datasources/services_remote_data_source.dart';
import 'features/servings/data/datasources/services_local_datasource.dart';
import 'features/servings/data/repository/comment_repository_impl.dart';
import 'features/servings/data/repository/services_repository_impl.dart';
import 'features/servings/domain/repository/comment_repository.dart';
import 'features/servings/domain/repository/servicesRepository.dart';
import 'features/servings/domain/usecases/comment/add_comment_usecase.dart';
import 'features/servings/domain/usecases/comment/get_comments_usecase.dart';
import 'features/servings/domain/usecases/comment/react_dislike_usecase.dart';
import 'features/servings/domain/usecases/comment/react_like_usecase.dart';
import 'features/servings/domain/usecases/comment/reply_to_comment_usecase.dart';
import 'features/servings/domain/usecases/service/add_service_usecase.dart';
import 'features/servings/domain/usecases/service/get_categories_usecase.dart';
import 'features/servings/domain/usecases/service/get_payment_units_usecase.dart';
import 'features/servings/domain/usecases/service/get_service_details_usecase.dart';
import 'features/servings/domain/usecases/service/get_availability_slots_usecase.dart';
import 'features/servings/presentation/bloc/comment/comment_bloc.dart';
import 'features/servings/presentation/bloc/service/services_bloc.dart';

import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repository/wallet_repository_impl.dart';
import 'features/wallet/domain/repository/wallet_repository.dart';
import 'features/wallet/domain/usecases/get_my_wallets_usecase.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

// Complaints Feature 📢
import 'features/complaints/data/datasources/complaint_remote_data_source.dart';
import 'features/complaints/data/repositories/complaint_repository_impl.dart';
import 'features/complaints/domain/repositories/i_complaint_repository.dart';
import 'features/complaints/domain/usecases/submit_complaint_usecase.dart';
import 'features/complaints/domain/usecases/get_complaint_status_usecase.dart';
import 'features/complaints/presentation/bloc/complaint_bloc.dart';

// Profile Feature 👤
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/i_profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== 0. External Libraries & Hive Setup 🚀 ====================
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  final localeBox = await Hive.openBox('locale_box');
  sl.registerLazySingleton<Box>(() => localeBox);

  if (!sl.isRegistered<Dio>()) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiStringConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authLocal = sl<AuthLocalDataSource>();
          final String? token = await authLocal.getToken();

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
  sl.registerFactory(() => ChatBloc(
    getChatsUseCase: sl(),
    getMessagesUseCase: sl(),
    sendMessageUseCase: sl(),
    createPersonalChatUseCase: sl(),
    createGroupChatUseCase: sl(),
    markAsReadUseCase: sl(),
    markAsReceivedUseCase: sl(),
    getMembersUseCase: sl(),
    addMembersUseCase: sl(),
    removeMemberUseCase: sl(),
    updateGroupUseCase: sl(),
    leaveGroupUseCase: sl(),
  ));
  sl.registerFactory(() => OtpBloc(sendOtpUseCase: sl()));
  sl.registerFactory(
        () => ServicesBloc(
      addServiceUseCase: sl(),
      getPaymentUnitsUseCase: sl(),
      getCategoriesUseCase: sl(),
      getServiceDetailsUseCase: sl(),
      getAvailabilitySlotsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => SignUpBloc(registerUseCase: sl()));
  sl.registerFactory(() => HomeBloc(
    searchServingsUseCase: sl(),
    getNearbyServingsUseCase: sl(), updateAvailabilityUseCase: sl(),
  ));
  sl.registerFactory(() => CommentBloc(
    getCommentsUseCase: sl(),
    addCommentUseCase: sl(),
    replyToCommentUseCase: sl(),
    reactLikeUseCase: sl(),
    reactDislikeUseCase: sl(),
  ));
  sl.registerFactory(() => RequestsBloc(
    getMyRequestsUseCase: sl(),
    createServingRequestUseCase: sl(),
    deleteRequestUseCase: sl(),
  ));
  sl.registerFactory(() => ReceivedRequestsBloc(
    getReceivedRequestsUseCase: sl(),
    acceptRequestUseCase: sl(),
    rejectRequestUseCase: sl(),
  ));
  sl.registerFactory(() => WalletBloc(getMyWalletsUseCase: sl()));
  sl.registerFactory(() => MyServingsBloc(
    getMyServingsUseCase: sl(),
    updateServingUseCase: sl(),
    toggleServingStatusUseCase: sl(),
  ));
  // ✅ تسجيل الـ UseCase الجديد أولاً (إذا لم تكن قد سجلته)
    // sl.registerLazySingleton(() => GetComplaintStatusUseCase(sl()));

    // ✅ تحديث الـ Bloc ليأخذ كلا المتطلبين
    sl.registerFactory(
      () => ComplaintBloc(
        submitComplaintUseCase: sl(),
        getComplaintStatusUseCase: sl(), // 👈 السطر الذي كان ناقصاً
      ),
    );
  // sl.registerFactory(() => ComplaintBloc(submitComplaintUseCase: sl()));
  sl.registerFactory(() => ProfileBloc(
    getUserProfileUseCase: sl(),
    updateProfileUseCase: sl(),
  ));

  // 🌟 حقن البلوك الخاص باللغة
  sl.registerFactory(() => LocaleBloc(localDataSource: sl()));

  // ==================== 2. Use Cases (LazySingleton) ====================
  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => CreatePersonalChatUseCase(sl()));
  sl.registerLazySingleton(() => CreateGroupChatUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReceivedUseCase(sl()));
  sl.registerLazySingleton(() => GetMembersUseCase(sl()));
  sl.registerLazySingleton(() => AddMembersUseCase(sl()));
  sl.registerLazySingleton(() => RemoveMemberUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGroupUseCase(sl()));
  sl.registerLazySingleton(() => LeaveGroupUseCase(sl()));
  sl.registerLazySingleton(() => AddServiceUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPaymentUnitsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetServiceDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailabilitySlotsUseCase(sl()));
  sl.registerLazySingleton(() => SearchServingsUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyServingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsForServingUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentOnServingUseCase(sl()));
  sl.registerLazySingleton(() => ReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => ReactLikeUseCase(sl()));
  sl.registerLazySingleton(() => ReactDislikeUseCase(sl()));
  sl.registerLazySingleton(() => GetMyRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateServingRequestUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetReceivedRequestsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetMyWalletsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyServingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateServingUseCase(sl()));
  sl.registerLazySingleton(() => ToggleServingStatusUseCase(sl()));
  sl.registerLazySingleton(() => SubmitComplaintUseCase(sl()));
  sl.registerLazySingleton(() => GetComplaintStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // ==================== 3. Repositories (LazySingleton) ====================
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<RequestRepository>(() => RequestRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<IComplaintRepository>(() => ComplaintRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<IProfileRepository>(() => ProfileRepositoryImpl(
    remoteDataSource: sl(),
    sharedPreferences: sl(),
  ));

  // ==================== 4. Data Sources (LazySingleton) ====================
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSourceImpl());
  sl.registerLazySingleton<ServicesRemoteDataSource>(() => ServicesRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ServicesLocalDataSource>(() => ServicesLocalDataSourceImpl());
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(secureStorage: sl()));
  sl.registerLazySingleton<CommentRemoteDataSource>(() => CommentRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<RequestRemoteDataSource>(() => RequestRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<WalletRemoteDataSource>(() => WalletRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ComplaintRemoteDataSource>(() => ComplaintRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(dio: sl()));

  sl.registerLazySingleton<LocaleLocalDataSource>(() => LocaleLocalDataSourceImpl(box: sl<Box>()));
}

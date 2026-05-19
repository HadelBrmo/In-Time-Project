import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'features/chat/data/datasources/chatRemoteDataSource.dart';
import 'features/chat/data/repository/chatRepositoryImpl.dart';
import 'features/chat/domain/repository/chatRepository.dart';
import 'features/chat/domain/usecases/deleteChatUseCase.dart';
import 'features/chat/domain/usecases/getChatsUseCase.dart';
import 'features/chat/domain/usecases/searchChatsUseCase.dart';
import 'features/chat/presentation/bloc/chatBloc/chatBloc.dart';

import 'features/strategies/data/datasources/services_remote_data_source.dart';
import 'features/strategies/data/repository/services_repository_impl.dart';
import 'features/strategies/domain/repository/servicesRepository.dart';
import 'features/strategies/domain/usecases/add_service_usecase.dart';
import 'features/strategies/presentation/bloc/services_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => ChatBloc(
    getChatsUseCase: sl(),
    deleteChatUseCase: sl(),
    searchChatsUseCase: sl(),
  ));
  sl.registerFactory(() => ServicesBloc(addServiceUseCase: sl()));

  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChatUseCase(sl()));
  sl.registerLazySingleton(() => SearchChatsUseCase(sl()));
  sl.registerLazySingleton(() => AddServiceUseCase(sl()));

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());

  sl.registerLazySingleton<ServicesRemoteDataSource>(() => ServicesRemoteDataSourceImpl(dio: sl()));

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => Dio());
  }
}
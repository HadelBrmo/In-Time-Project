import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/locale_local_data_source.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleLocalDataSource localDataSource;

  LocaleBloc({required this.localDataSource})
      : super(LocaleState(Locale(localDataSource.getCachedLanguageCode()))) {

    on<ChangeLocaleEvent>((event, emit) async {
      await localDataSource.cacheLanguageCode(event.languageCode);
      emit(LocaleState(Locale(event.languageCode)));
    });

    on<GetSavedLocaleEvent>((event, emit) {
      final langCode = localDataSource.getCachedLanguageCode();
      emit(LocaleState(Locale(langCode)));
    });
  }
}
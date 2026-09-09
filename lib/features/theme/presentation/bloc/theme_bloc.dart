import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/theme_local_data_source.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeLocalDataSource localDataSource;

  ThemeBloc({required this.localDataSource})
      : super(ThemeState(localDataSource.isDarkMode() ? ThemeMode.dark : ThemeMode.light)) {

    on<ToggleThemeEvent>((event, emit) async {
      final isDark = state.themeMode == ThemeMode.dark;
      await localDataSource.cacheThemeMode(!isDark);
      emit(ThemeState(!isDark ? ThemeMode.dark : ThemeMode.light));
    });

    on<GetSavedThemeEvent>((event, emit) {
      final isDark = localDataSource.isDarkMode();
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    });
  }
}

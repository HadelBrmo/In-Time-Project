import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/settings_local_data_source.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsLocalDataSource localDataSource;

  SettingsBloc({required this.localDataSource})
      : super(SettingsState(animationsEnabled: localDataSource.isAnimationsEnabled())) {
    
    on<ToggleAnimationsEvent>((event, emit) async {
      await localDataSource.cacheAnimationsEnabled(event.enabled);
      emit(state.copyWith(animationsEnabled: event.enabled));
    });

    on<GetSavedSettingsEvent>((event, emit) {
      final enabled = localDataSource.isAnimationsEnabled();
      emit(state.copyWith(animationsEnabled: enabled));
    });
  }
}

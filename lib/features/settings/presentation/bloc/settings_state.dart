import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool animationsEnabled;

  const SettingsState({this.animationsEnabled = false});

  SettingsState copyWith({bool? animationsEnabled}) {
    return SettingsState(
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  @override
  List<Object?> get props => [animationsEnabled];
}

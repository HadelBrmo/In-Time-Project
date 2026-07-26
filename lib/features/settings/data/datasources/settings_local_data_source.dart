import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> cacheAnimationsEnabled(bool enabled);
  bool isAnimationsEnabled();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  static const String _animationsKey = 'animations_enabled';

  @override
  Future<void> cacheAnimationsEnabled(bool enabled) async {
    await sharedPreferences.setBool(_animationsKey, enabled);
  }

  @override
  bool isAnimationsEnabled() {
    return sharedPreferences.getBool(_animationsKey) ?? true;
  }
}

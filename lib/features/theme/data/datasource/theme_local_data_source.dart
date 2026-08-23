import 'package:hive/hive.dart';

abstract class ThemeLocalDataSource {
  Future<void> cacheThemeMode(bool isDarkMode);
  bool isDarkMode();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final Box box;
  final String _themeKey = 'is_dark_mode';

  ThemeLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheThemeMode(bool isDarkMode) async {
    await box.put(_themeKey, isDarkMode);
  }

  @override
  bool isDarkMode() {
    return box.get(_themeKey, defaultValue: false);
  }
}

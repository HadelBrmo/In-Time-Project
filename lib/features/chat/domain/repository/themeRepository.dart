abstract class ThemeRepository {
  Future<bool> getThemeStatus();
  Future<void> saveThemeStatus(bool isDark);
}
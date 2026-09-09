import 'package:hive/hive.dart';

abstract class LocaleLocalDataSource {
  Future<void> cacheLanguageCode(String languageCode);
  String getCachedLanguageCode();
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  final Box box;
  final String _langKey = 'cached_language_code';

  LocaleLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheLanguageCode(String languageCode) async {
    await box.put(_langKey, languageCode);
  }

  @override
  String getCachedLanguageCode() {
    return box.get(_langKey, defaultValue: 'ar');
  }
}
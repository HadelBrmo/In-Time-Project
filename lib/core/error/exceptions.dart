class AppExceptions implements Exception {
  final String message;
  AppExceptions(this.message);
}

class ServerException extends AppExceptions {
  ServerException(String message) : super(message);
}

class CacheException extends AppExceptions {
  CacheException(String message) : super(message);
}
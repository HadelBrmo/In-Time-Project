import 'package:http/http.dart' as dio;

class AppExceptions {}

class ServerException {}

class CacheException {}


class ServerExceptionWithDetails implements Exception {
  final int? statusCode;
  final String message;
  ServerExceptionWithDetails({this.statusCode, required this.message});
}



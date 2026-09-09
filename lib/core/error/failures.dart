import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];

  String get message => "";
}

class ServerFailure extends Failure {
  final String serverMessage;

  ServerFailure([this.serverMessage = "حدث خطأ في الاتصال بالسيرفر"]);

  @override
  String get message => serverMessage;

  @override
  List<Object?> get props => [serverMessage];
}

class CacheFailure extends Failure {}

class ServerFailureWithDetails extends Failure {
  final int? statusCode;
  final String message;

  ServerFailureWithDetails({this.statusCode, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}
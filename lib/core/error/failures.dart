import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class ServerFailureWithDetails extends Failure {
  final int? statusCode;
  final String message;

  ServerFailureWithDetails({this.statusCode, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}

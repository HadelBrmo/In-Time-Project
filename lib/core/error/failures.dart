abstract class Failure {}

class ServerFailure {}

class CacheFailure {}


class ServerFailureWithDetails extends Failure {
  final int? statusCode;
  final String message;

   ServerFailureWithDetails({this.statusCode, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}


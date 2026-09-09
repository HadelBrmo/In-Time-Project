import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/request_repository.dart';

class CreateServingRequestUseCase {
  final RequestRepository repository;

  CreateServingRequestUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required int servingId,
    String? message,
    int? automaticallyCancelAfter,
  }) async {
    return await repository.createServingRequest(
      servingId: servingId,
      message: message,
      automaticallyCancelAfter: automaticallyCancelAfter,
    );
  }
}
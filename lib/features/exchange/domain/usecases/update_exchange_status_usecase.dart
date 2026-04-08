import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class UpdateExchangeStatusUseCase implements UseCase<void, UpdateStatusParams> {
  @override
  Future<Either<Failure, void>> call(UpdateStatusParams params) async {
    throw UnimplementedError();
  }
}

class UpdateStatusParams {
  final String requestId;
  final String status;

  UpdateStatusParams({required this.requestId, required this.status});
}
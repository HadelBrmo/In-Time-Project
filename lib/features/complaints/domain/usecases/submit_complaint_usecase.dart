import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/complaint_entity.dart';

class SubmitComplaintUseCase implements UseCase<ComplaintEntity, SubmitParams> {
  @override
  Future<Either<Failure, ComplaintEntity>> call(SubmitParams params) async {
    throw UnimplementedError();
  }
}

class SubmitParams {
  final String title;
  final String description;

  SubmitParams({required this.title, required this.description});
}
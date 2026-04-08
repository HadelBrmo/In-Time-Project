import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/complaint_entity.dart';

class GetComplaintStatusUseCase implements UseCase<ComplaintEntity, GetStatusParams> {
  @override
  Future<Either<Failure, ComplaintEntity>> call(GetStatusParams params) async {
    throw UnimplementedError();
  }
}

class GetStatusParams {
  final String complaintId;

  GetStatusParams({required this.complaintId});
}
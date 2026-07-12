import '../../domain/repositories/i_complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';
import '../models/complaint_model.dart';
import '../models/complaint_request.dart';

class ComplaintRepositoryImpl implements IComplaintRepository {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request) async {
    return await remoteDataSource.submitComplaint(request);
  }
}

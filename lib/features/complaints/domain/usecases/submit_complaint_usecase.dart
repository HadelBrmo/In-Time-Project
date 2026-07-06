import '../repositories/i_complaint_repository.dart';
import '../../data/models/complaint_request.dart';
import '../../data/models/complaint_model.dart';

class SubmitComplaintUseCase {
  final IComplaintRepository repository;

  SubmitComplaintUseCase(this.repository);

  Future<ComplaintResponse> call(ComplaintRequest request) async {
    return await repository.submitComplaint(request);
  }
}

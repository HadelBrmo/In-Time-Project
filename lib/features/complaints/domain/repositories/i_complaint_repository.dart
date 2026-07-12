import '../../data/models/complaint_request.dart';
import '../../data/models/complaint_model.dart';

abstract class IComplaintRepository {
  Future<List<dynamic>> getMyComplaints();
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request);
}

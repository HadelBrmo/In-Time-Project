import '../../data/models/complaint_request.dart';
import '../../data/models/complaint_model.dart';

abstract class IComplaintRepository {
  Future<List<dynamic>> getMyComplaints();
  Future<List<dynamic>> getComplaintsAgainstMe();
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request);
  Future<void> uploadComplaintDocuments(int complaintId, List<String> filePaths);
}

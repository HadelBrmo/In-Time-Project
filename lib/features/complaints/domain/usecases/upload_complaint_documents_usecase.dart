import '../repositories/i_complaint_repository.dart';

class UploadComplaintDocumentsUseCase {
  final IComplaintRepository repository;

  UploadComplaintDocumentsUseCase(this.repository);

  Future<void> call(int complaintId, List<String> filePaths) async {
    return await repository.uploadComplaintDocuments(complaintId, filePaths);
  }
}

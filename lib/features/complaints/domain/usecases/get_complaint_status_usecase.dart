import '../repositories/i_complaint_repository.dart';

class GetComplaintStatusUseCase {
  final IComplaintRepository repository;

  GetComplaintStatusUseCase(this.repository);

  Future<List<dynamic>> call() async {
    return await repository.getMyComplaints();
  }
}
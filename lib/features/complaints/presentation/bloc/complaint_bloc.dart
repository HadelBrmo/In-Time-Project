import 'package:flutter_bloc/flutter_bloc.dart';
import 'complaint_event.dart';
import 'complaint_state.dart';
import '../../domain/usecases/submit_complaint_usecase.dart';
import '../../domain/usecases/get_complaint_status_usecase.dart';
import '../../domain/usecases/upload_complaint_documents_usecase.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final SubmitComplaintUseCase submitComplaintUseCase;
  final GetComplaintStatusUseCase getComplaintStatusUseCase;
  final UploadComplaintDocumentsUseCase uploadComplaintDocumentsUseCase;

  ComplaintBloc({
    required this.submitComplaintUseCase,
    required this.getComplaintStatusUseCase,
    required this.uploadComplaintDocumentsUseCase,
  }) : super(ComplaintInitial()) {
    
    on<SubmitComplaintEvent>((event, emit) async {
      emit(ComplaintSubmitting());
      try {
        // يتم إرسال الشكوى مع الملفات في طلب واحد الآن
        final response = await submitComplaintUseCase(event.request);
        emit(ComplaintSuccess(response));
      } catch (e) {
        emit(ComplaintError(e.toString()));
      }
    });

    // ✅ الحدث الجديد لجلب الشكاوى الخاصة بي
    on<FetchMyComplaintsEvent>((event, emit) async {
      emit(MyComplaintsLoading());
      try {
        final complaints = await getComplaintStatusUseCase();
        emit(MyComplaintsLoaded(complaints));
      } catch (e) {
        emit(ComplaintError(e.toString()));
      }
    });
  }
}

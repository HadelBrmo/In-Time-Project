import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/create_serving_request_usecase.dart';
import '../../domain/usecases/delete_request_usecase.dart';
import '../../domain/usecases/get_my_requests_usecase.dart';
import '../../domain/usecases/handle_completion_usecases.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final GetMyRequestsUseCase getMyRequestsUseCase;
  final CreateServingRequestUseCase createServingRequestUseCase;
  final DeleteRequestUseCase deleteRequestUseCase;
  final RequestCompletionUseCase requestCompletionUseCase;
  final ConfirmCompletionUseCase confirmCompletionUseCase;
  final RequestRevisionUseCase requestRevisionUseCase;
  final DisputeRequestUseCase disputeRequestUseCase;
  final GetPendingConfirmationsUseCase getPendingConfirmationsUseCase;

  RequestsBloc({
    required this.getMyRequestsUseCase,
    required this.createServingRequestUseCase,
    required this.deleteRequestUseCase,
    required this.requestCompletionUseCase,
    required this.confirmCompletionUseCase,
    required this.requestRevisionUseCase,
    required this.disputeRequestUseCase,
    required this.getPendingConfirmationsUseCase,
  }) : super(RequestsInitialState()) {

    on<FetchMyRequestsEvent>((event, emit) async {
      emit(RequestsLoadingState());
      final result = await getMyRequestsUseCase(status: event.status);
      result.fold(
            (failure) {
          if (failure is ServerFailure) {
            emit(const RequestsErrorState(message: 'فشل الاتصال بالسيرفر'));
          } else {
            emit(const RequestsErrorState(message: "حدث خطأ أثناء الاتصال بالشبكة"));
          }
        },
            (requests) => emit(RequestsLoadedState(requests)),
      );
    });

    on<CreateServingRequestEvent>((event, emit) async {
      emit(CreateRequestLoadingState());
      final result = await createServingRequestUseCase(
        servingId: event.servingId,
        message: event.message,
        automaticallyCancelAfter: event.automaticallyCancelAfter,
      );
      result.fold(
            (failure) {
          if (failure is ServerFailure) {
            emit(const CreateRequestErrorState("فشل الاتصال بالسيرفر، يرجى المحاولة لاحقاً"));
          } else {
            emit(const CreateRequestErrorState("حدث خطأ أثناء إرسال الطلب"));
          }
        },
            (successMessage) => emit(CreateRequestSuccessState(successMessage)),
      );
    });

    on<DeleteRequestEvent>((event, emit) async {
      final result = await deleteRequestUseCase(event.requestId);

      result.fold(
            (failure) {
          if (failure is ServerFailure) {
            emit(const RequestDeleteErrorState(message: "فشل السيرفر في حذف الطلب"));
          } else {
            emit(const RequestDeleteErrorState(message: "حدث خطأ غير متوقع أثناء الحذف"));
          }
        },
            (successMessage) {
          emit(RequestDeletedSuccessState());
        },
      );
    });

    on<RequestCompletionEvent>((event, emit) async {
      emit(RequestActionLoadingState());
      final result = await requestCompletionUseCase(event.requestId);
      result.fold(
        (failure) => emit(const RequestActionErrorState("فشل إرسال طلب الإكمال")),
        (_) => emit(const RequestActionSuccessState("تم إرسال طلب إكمال الخدمة بنجاح")),
      );
    });

    on<ConfirmCompletionEvent>((event, emit) async {
      emit(RequestActionLoadingState());
      final result = await confirmCompletionUseCase(event.requestId);
      result.fold(
        (failure) => emit(const RequestActionErrorState("فشل تأكيد الإكمال")),
        (_) => emit(const RequestActionSuccessState("تم تأكيد إكمال الخدمة بنجاح")),
      );
    });

    on<RequestRevisionEvent>((event, emit) async {
      emit(RequestActionLoadingState());
      final result = await requestRevisionUseCase(event.requestId, event.days);
      result.fold(
        (failure) => emit(const RequestActionErrorState("فشل طلب التعديل")),
        (_) => emit(const RequestActionSuccessState("تم إرسال طلب التعديل بنجاح")),
      );
    });

    on<DisputeRequestEvent>((event, emit) async {
      emit(RequestActionLoadingState());
      final result = await disputeRequestUseCase(event.requestId);
      result.fold(
        (failure) => emit(const RequestActionErrorState("فشل فتح نزاع")),
        (_) => emit(const RequestActionSuccessState("تم فتح نزاع لدى الإدارة")),
      );
    });

    on<FetchPendingConfirmationsEvent>((event, emit) async {
      emit(RequestsLoadingState());
      final result = await getPendingConfirmationsUseCase();
      result.fold(
        (failure) => emit(const RequestsErrorState(message: "فشل جلب التأكيدات المعلقة")),
        (requests) => emit(PendingConfirmationsLoadedState(requests)),
      );
    });
  }
}

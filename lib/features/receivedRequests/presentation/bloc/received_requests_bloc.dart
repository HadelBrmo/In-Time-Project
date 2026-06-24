import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/accept_request_usecase.dart';
import '../../domain/usecases/get_received_requests_usecase.dart';
import '../../domain/usecases/reject_request_usecase.dart';
import 'received_requests_event.dart';
import 'received_requests_state.dart';

class ReceivedRequestsBloc extends Bloc<ReceivedRequestsEvent, ReceivedRequestsState> {
  final GetReceivedRequestsUseCase getReceivedRequestsUseCase;
  final AcceptRequestUseCase acceptRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;

  ReceivedRequestsBloc({
    required this.getReceivedRequestsUseCase,
    required this.acceptRequestUseCase,
    required this.rejectRequestUseCase,
  }) : super(ReceivedRequestsInitialState()) {

    on<FetchReceivedRequestsEvent>((event, emit) async {
      emit(ReceivedRequestsLoadingState());

      final result = await getReceivedRequestsUseCase();

      result.fold(
            (failure) => emit(const ReceivedRequestsErrorState(message: "حدث خطأ أثناء تحميل الطلبات الواردة")),
            (groups) => emit(ReceivedRequestsLoadedState(groups)),
      );
    });

    on<AcceptRequestEvent>((event, emit) async {
      emit(AcceptRequestLoadingState());
      final result = await acceptRequestUseCase(event.requestId);
      result.fold(
            (failure) => emit(AcceptRequestErrorState("عذراً، فشل قبول الطلب")),
            (_) => emit(AcceptRequestSuccessState()),
      );
    });

    on<RejectRequestEvent>((event, emit) async {
      emit(RejectRequestLoadingState());
      final result = await rejectRequestUseCase(event.requestId);
      result.fold(
            (failure) => emit(RejectRequestErrorState("عذراً، فشل رفض الطلب")),
            (_) => emit(RejectRequestSuccessState()),
      );
    });
  }
  }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_received_requests_usecase.dart';
import 'received_requests_event.dart';
import 'received_requests_state.dart';

class ReceivedRequestsBloc extends Bloc<ReceivedRequestsEvent, ReceivedRequestsState> {
  final GetReceivedRequestsUseCase getReceivedRequestsUseCase;

  ReceivedRequestsBloc({required this.getReceivedRequestsUseCase}) : super(ReceivedRequestsInitialState()) {
    on<FetchReceivedRequestsEvent>((event, emit) async {
      emit(ReceivedRequestsLoadingState());

      final result = await getReceivedRequestsUseCase();

      result.fold(
            (failure) => emit(const ReceivedRequestsErrorState(message: "حدث خطأ أثناء تحميل الطلبات الواردة")),
            (groups) => emit(ReceivedRequestsLoadedState(groups)),
      );
    });
  }
}
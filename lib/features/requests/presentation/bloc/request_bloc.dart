import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart'; // تأكدي من توافق كلاس الـ Failure عندك
import '../../domain/usecases/get_my_requests_usecase.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final GetMyRequestsUseCase getMyRequestsUseCase;

  RequestsBloc({required this.getMyRequestsUseCase}) : super(RequestsInitialState()) {

    on<FetchMyRequestsEvent>((event, emit) async {
      emit(RequestsLoadingState());

      final result = await getMyRequestsUseCase();

      result.fold(
            (failure) {
          if (failure is ServerFailure) {
            emit(RequestsErrorState(message: 'فشل الاتصال بالسيرفر'

            ));
          } else {
            emit(const RequestsErrorState(message: "حدث خطأ أثناء الاتصال بالشبكة"));
          }
        },
            (requests) => emit(RequestsLoadedState(requests)),
      );
    });

  }
}
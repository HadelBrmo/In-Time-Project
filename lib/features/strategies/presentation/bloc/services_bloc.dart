// features/services/presentation/bloc/services_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_service_usecase.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final AddServiceUseCase addServiceUseCase;

  ServicesBloc({required this.addServiceUseCase}) : super(ServicesInitial()) {
    on<AddServiceSubmittedEvent>(_onAddServiceSubmitted);
  }

  Future<void> _onAddServiceSubmitted(
      AddServiceSubmittedEvent event,
      Emitter<ServicesState> emit,
      ) async {
    emit(AddServiceLoadingState());

    final result = await addServiceUseCase.call(
      service: event.service,
      image: event.image,
    );
    result.fold(
          (failure) {
        if (failure is ServerFailureWithDetails) {
          emit(AddServiceErrorState(
              errorMessage: failure.message,
              statusCode: failure.statusCode
          ));
        } else {
          emit(const AddServiceErrorState(errorMessage: "حدث خطأ غير متوقع"));
        }
      },
          (success) => emit(AddServiceSuccessState()),
    );
  }
}
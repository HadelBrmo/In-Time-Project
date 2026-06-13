
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/service/add_service_usecase.dart';
import '../../../domain/usecases/service/get_payment_units_usecase.dart'; // مستوردة صح
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final AddServiceUseCase addServiceUseCase;
  final GetPaymentUnitsUseCase getPaymentUnitsUseCase;

  ServicesBloc({
    required this.addServiceUseCase,
    required this.getPaymentUnitsUseCase,
  }) : super(ServicesInitial()) {

    on<AddServiceSubmittedEvent>(_onAddServiceSubmitted);
    on<GetPaymentUnitsEvent>(_onGetPaymentUnits);
  }

  Future<void> _onAddServiceSubmitted(
      AddServiceSubmittedEvent event,
      Emitter<ServicesState> emit,
      ) async {
    emit(AddServiceLoadingState());

    final result = await addServiceUseCase.call(
      service: event.service,
      image: event.image,
      endpoint: event.endpoint,
    );
    result.fold(
          (failure) {
        if (failure is ServerFailureWithDetails) {
          emit(AddServiceErrorState(
            errorMessage: failure.message,
            statusCode: failure.statusCode,
          ));
        } else {
          emit(const AddServiceErrorState(errorMessage: "حدث خطأ غير متوقع"));
        }
      },
          (success) => emit(AddServiceSuccessState()),
    );
  }

  Future<void> _onGetPaymentUnits(
      GetPaymentUnitsEvent event,
      Emitter<ServicesState> emit,
      ) async {
    emit(GetPaymentUnitsLoadingState());

    final result = await getPaymentUnitsUseCase.call();
    result.fold(
          (failure) => emit(const GetPaymentUnitsErrorState("فشل جلب وحدات الدفع")),
          (units) => emit(GetPaymentUnitsSuccessState(units)),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/service/add_service_usecase.dart';
import '../../../domain/usecases/service/get_categories_usecase.dart';
import '../../../domain/usecases/service/get_payment_units_usecase.dart';
import '../../../domain/usecases/service/get_service_details_usecase.dart';
import '../../../domain/usecases/service/get_availability_slots_usecase.dart';
import '../../../domain/entity/service_entity.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final AddServiceUseCase addServiceUseCase;
  final GetPaymentUnitsUseCase getPaymentUnitsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetServiceDetailsUseCase getServiceDetailsUseCase;
  final GetAvailabilitySlotsUseCase getAvailabilitySlotsUseCase;

  ServicesBloc({
    required this.addServiceUseCase,
    required this.getPaymentUnitsUseCase,
    required this.getCategoriesUseCase,
    required this.getServiceDetailsUseCase,
    required this.getAvailabilitySlotsUseCase,
  }) : super(ServicesInitial()) {
    on<AddServiceSubmittedEvent>(_onAddServiceSubmitted);
    on<GetPaymentUnitsEvent>(_onGetPaymentUnits);
    on<GetCategoriesEvent>(_onGetCategories);
    on<GetServiceDetailsEvent>(_onGetServiceDetails);
    on<GetAvailabilitySlotsEvent>(_onGetAvailabilitySlots);
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

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(GetCategoriesLoadingState());

    final result = await getCategoriesUseCase.call();
    result.fold(
      (failure) => emit(const GetCategoriesErrorState("فشل جلب التصنيفات")),
      (categories) => emit(GetCategoriesSuccessState(categories)),
    );
  }

  Future<void> _onGetServiceDetails(
    GetServiceDetailsEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServiceDetailsLoading());

    final result = await getServiceDetailsUseCase.call(event.serviceId);
    
    await result.fold(
      (failure) async {
        if (failure is ServerFailureWithDetails) {
          emit(ServiceDetailsError(failure.message));
        } else {
          emit(const ServiceDetailsError("حدث خطأ في تحميل تفاصيل الخدمة"));
        }
      },
      (service) async {
        final slotsResult = await getAvailabilitySlotsUseCase.call(event.serviceId);
        
        slotsResult.fold(
          (failure) => emit(ServiceDetailsLoaded(service)),
          (slots) {
            final updatedService = service.copyWith(availabilitySlots: slots);
            emit(ServiceDetailsLoaded(updatedService));
          },
        );
      },
    );
  }

  Future<void> _onGetAvailabilitySlots(
    GetAvailabilitySlotsEvent event,
    Emitter<ServicesState> emit,
  ) async {
    final result = await getAvailabilitySlotsUseCase.call(event.serviceId);
    if (state is ServiceDetailsLoaded) {
      final currentService = (state as ServiceDetailsLoaded).service;
      result.fold(
        (failure) => null,
        (slots) {
          final updatedService = currentService.copyWith(availabilitySlots: slots);
          emit(ServiceDetailsLoaded(updatedService));
        },
      );
    }
  }
}

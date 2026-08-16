import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../servings/domain/entity/service_entity.dart';
import '../../domain/usecases/get_nearby_servings_use_case.dart';
import '../../domain/usecases/search_services_usecase.dart';
import '../../domain/usecases/update_availability_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchServingsUseCase searchServingsUseCase;
  final GetNearbyServingsUseCase getNearbyServingsUseCase;
  final UpdateAvailabilityUseCase updateAvailabilityUseCase;

  HomeBloc({
    required this.searchServingsUseCase,
    required this.getNearbyServingsUseCase,
    required this.updateAvailabilityUseCase,
  }) : super(HomeInitialState()) {

    on<FetchHomeServingsEvent>((event, emit) async {
      List<ServiceEntity> oldServings = [];
      if (!event.isRefresh && state is HomeSuccessState) {
        oldServings = (state as HomeSuccessState).servings;
      }

      if (event.isRefresh) {
        emit(HomeLoadingState());
      }

      try {
        final newServings = await searchServingsUseCase(
          servingTypeId: event.servingTypeId,
          paymentUnitId: event.paymentUnitId,
          servingCategoryId: event.servingCategoryId,
          name: event.name,
          skip: event.skip,
          take: event.take,
        );

        final activeNewServings = newServings.where((s) => s.status == 'active' || s.status == null).toList();

        final fullList = event.isRefresh ? activeNewServings : [...oldServings, ...activeNewServings];
        emit(HomeSuccessState(servings: fullList));
      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
    });

    on<FetchNearbyServingsEvent>((event, emit) async {
      List<ServiceEntity> oldServings = [];
      if (!event.isRefresh && state is HomeSuccessState) {
        oldServings = (state as HomeSuccessState).servings;
      }

      if (event.isRefresh) {
        emit(HomeLoadingState());
      }

      final failureOrData = await getNearbyServingsUseCase(
        lat: event.lat,
        lng: event.lng,
        skip: event.skip,
        take: event.take,
      );

      failureOrData.fold(
            (failure) => emit(HomeErrorState(message: "فشل جلب الخدمات القريبة")),
            (newServings) {
          final activeNewServings = newServings.where((s) => s.status == 'active' || s.status == null).toList();
          final fullList = event.isRefresh ? activeNewServings : [...oldServings, ...activeNewServings];
          emit(HomeSuccessState(servings: fullList));
        },
      );
    });

    on<RequestServiceEvent>((event, emit) {
      if (state is HomeSuccessState) {
        final currentState = state as HomeSuccessState;
        final updatedServings = currentState.servings.map((serving) {
          if (serving.id == event.serviceId) {
            return _cloneServiceWithRequestedStatus(serving, true);
          }
          return serving;
        }).toList();
        emit(HomeSuccessState(servings: updatedServings));
      }
    });

    on<CancelServiceRequestEvent>((event, emit) {
      if (state is HomeSuccessState) {
        final currentState = state as HomeSuccessState;
        final updatedServings = currentState.servings.map((serving) {
          if (serving.id == event.serviceId) {
            return _cloneServiceWithRequestedStatus(serving, false);
          }
          return serving;
        }).toList();
        emit(HomeSuccessState(servings: updatedServings));
      }
    });

    on<UpdateServiceAvailabilityEvent>((event, emit) async {
      try {
        emit(HomeLoadingState());

        final failureOrSuccess = await updateAvailabilityUseCase(
            serviceId: event.serviceId,
            data: event.slotsData
        );

        failureOrSuccess.fold(
          (failure) => emit(const HomeErrorState(message: "فشل تحديث المواعيد")),
          (_) => emit(UpdateAvailabilitySuccessState()),
        );

      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
    });
  }


  ServiceEntity _cloneServiceWithRequestedStatus(ServiceEntity old, bool newStatus) {
    return ServiceEntity(
      id: old.id,
      title: old.title,
      description: old.description,
      categoryId: old.categoryId,
      costAmount: old.costAmount,
      unitId: old.unitId,
      locationAddress: old.locationAddress,
      locationLat: old.locationLat,
      locationLng: old.locationLng,
      meetingType: old.meetingType,
      imageUrl: old.imageUrl,
      userFullName: old.userFullName,
      userEmail: old.userEmail,
      categoryName: old.categoryName,
      unitName: old.unitName,
      servingTypeName: old.servingTypeName,
      isRequested: newStatus,
      isOwner: old.isOwner,
      status: old.status,
      availabilitySlots: old.availabilitySlots,
      createdAt: old.createdAt,
    );
  }
}

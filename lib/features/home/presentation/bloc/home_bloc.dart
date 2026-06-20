import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/search_services_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchServingsUseCase searchServingsUseCase;

  HomeBloc({required this.searchServingsUseCase}) : super(HomeInitialState()) {

    on<FetchHomeServingsEvent>((event, emit) async {
      List<ServicingEntity> oldServings = [];
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

        final fullList = event.isRefresh ? newServings : [...oldServings, ...newServings];

        emit(HomeSuccessState(servings: fullList));
      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
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
  }

  ServicingEntity _cloneServiceWithRequestedStatus(ServicingEntity old, bool newStatus) {
    return ServicingEntity(
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
    );
  }

}

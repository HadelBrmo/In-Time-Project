import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class FetchHomeServingsEvent extends HomeEvent {
  final int? servingTypeId;
  final int? paymentUnitId;
  final int? servingCategoryId;
  final String? name;
  final int? skip;
  final int? take;
  final bool isRefresh;

  const FetchHomeServingsEvent({
    this.servingTypeId,
    this.paymentUnitId,
    this.servingCategoryId,
    this.name,
    this.skip,
    this.take,
    required this.isRefresh,
  });

  @override
  List<Object?> get props => [servingTypeId, paymentUnitId, servingCategoryId, name, skip, take, isRefresh];
}

class RequestServiceEvent extends HomeEvent {
  final int serviceId;
  const RequestServiceEvent({required this.serviceId});
  @override
  List<Object?> get props => [serviceId];
}

class CancelServiceRequestEvent extends HomeEvent {
  final int serviceId;
  const CancelServiceRequestEvent({required this.serviceId});
  @override
  List<Object?> get props => [serviceId];
}

class FetchNearbyServingsEvent extends HomeEvent {
  final double lat;
  final double lng;
  final int skip;
  final int take;
  final bool isRefresh;

  const FetchNearbyServingsEvent({
    required this.lat,
    required this.lng,
    required this.skip,
    required this.take,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [lat, lng, skip, take, isRefresh];
}

class FetchProposedServingsEvent extends HomeEvent {
  final int skip;
  final int take;

  const FetchProposedServingsEvent({
    required this.skip,
    required this.take,
  });

  @override
  List<Object?> get props => [skip, take];
}

class UpdateServiceAvailabilityEvent extends HomeEvent {
  final int serviceId;
  final Map<String, dynamic> slotsData;

  const UpdateServiceAvailabilityEvent({
    required this.serviceId,
    required this.slotsData,
  });

  @override
  List<Object?> get props => [serviceId, slotsData];
}
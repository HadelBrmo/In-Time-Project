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
  List<Object?> get props => [
    servingTypeId,
    paymentUnitId,
    servingCategoryId,
    name,
    skip,
    take,
    isRefresh,
  ];
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

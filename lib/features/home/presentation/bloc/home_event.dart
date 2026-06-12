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

  const FetchHomeServingsEvent({
    this.servingTypeId,
    this.paymentUnitId,
    this.servingCategoryId,
    this.name, required bool isRefresh,
  });

  @override
  List<Object?> get props => [servingTypeId, paymentUnitId, servingCategoryId, name];
}
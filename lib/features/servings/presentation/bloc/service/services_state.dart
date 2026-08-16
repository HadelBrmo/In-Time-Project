import 'package:equatable/equatable.dart';

import '../../../domain/entity/category_entity.dart';
import '../../../domain/entity/payment_unit_entity.dart';
import '../../../domain/entity/service_entity.dart';
import '../../../domain/entity/serving_type_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class AddServiceLoadingState extends ServicesState {}

class AddServiceSuccessState extends ServicesState {}

class AddServiceErrorState extends ServicesState {
  final String errorMessage;

  const AddServiceErrorState({required this.errorMessage, int? statusCode});

  @override
  List<Object?> get props => [errorMessage];
}

class GetPaymentUnitsLoadingState extends ServicesState {}

class GetPaymentUnitsSuccessState extends ServicesState {
  final List<PaymentUnitEntity> units;
  const GetPaymentUnitsSuccessState(this.units);
  @override
  List<Object?> get props => [units];
}

class GetPaymentUnitsErrorState extends ServicesState {
  final String message;
  const GetPaymentUnitsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetCategoriesLoadingState extends ServicesState {}

class GetCategoriesSuccessState extends ServicesState {
  final List<CategoryEntity> categories;
  const GetCategoriesSuccessState(this.categories);
  @override
  List<Object?> get props => [categories];
}

class GetCategoriesErrorState extends ServicesState {
  final String message;
  const GetCategoriesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetServingTypesLoadingState extends ServicesState {}

class GetServingTypesSuccessState extends ServicesState {
  final List<ServingTypeEntity> types;
  const GetServingTypesSuccessState(this.types);
  @override
  List<Object?> get props => [types];
}

class GetServingTypesErrorState extends ServicesState {
  final String message;
  const GetServingTypesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceDetailsLoading extends ServicesState {}

class ServiceDetailsLoaded extends ServicesState {
  final ServiceEntity service;
  const ServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ServiceDetailsError extends ServicesState {
  final String message;
  const ServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RateServiceLoadingState extends ServicesState {}

class RateServiceSuccessState extends ServicesState {}

class RateServiceErrorState extends ServicesState {
  final String message;
  const RateServiceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}


import 'package:equatable/equatable.dart';

import '../../../domain/entity/payment_unit_entity.dart';

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
}
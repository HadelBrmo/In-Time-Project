// features/services/presentation/bloc/services_state.dart

import 'package:equatable/equatable.dart';

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
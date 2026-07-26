import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:in_time/features/servings/domain/entity/service_entity.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class AddServiceSubmittedEvent extends ServicesEvent {
  final ServiceEntity service;
  final XFile? image;
  final String endpoint;

  const AddServiceSubmittedEvent({
    required this.service,
    required this.image,
    required this.endpoint,
  });

  @override
  List<Object?> get props => [service, image, endpoint];
}

class GetPaymentUnitsEvent extends ServicesEvent {}

class GetCategoriesEvent extends ServicesEvent {}

class GetServiceDetailsEvent extends ServicesEvent {
  final int serviceId;

  const GetServiceDetailsEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

class GetAvailabilitySlotsEvent extends ServicesEvent {
  final int serviceId;

  const GetAvailabilitySlotsEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

class RateServingEvent extends ServicesEvent {
  final int serviceId;
  final double rating;

  const RateServingEvent(this.serviceId, this.rating);

  @override
  List<Object?> get props => [serviceId, rating];
}

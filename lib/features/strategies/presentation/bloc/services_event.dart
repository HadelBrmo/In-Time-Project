
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entity/service_entity.dart';

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
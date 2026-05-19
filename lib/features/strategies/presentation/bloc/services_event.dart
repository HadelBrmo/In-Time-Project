// features/services/presentation/bloc/services_event.dart

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

  const AddServiceSubmittedEvent({
    required this.service,
    required this.image,
  });

  @override
  List<Object?> get props => [service, image];
}
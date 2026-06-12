// features/services/domain/entities/service_entity.dart

import 'package:equatable/equatable.dart';

class ServicingEntity extends Equatable {
  final String title;
  final String description;
  final String categoryId;
  final String costAmount;
  final String? unitId;
  final String locationAddress;
  final double locationLat;
  final double locationLng;
  final String? meetingType;
  final String? imageUrl;

  const ServicingEntity({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.costAmount,
    this.unitId,
    required this.locationAddress,
    required this.locationLat,
    required this.locationLng,
    this.meetingType,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    categoryId,
    costAmount,
    unitId,
    locationAddress,
    locationLat,
    locationLng,
    meetingType,
    imageUrl,
  ];
}
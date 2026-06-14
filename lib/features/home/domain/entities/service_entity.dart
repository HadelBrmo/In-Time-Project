// features/services/domain/entities/service_entity.dart
import 'package:equatable/equatable.dart';

class ServicingEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String? categoryId;
  final String? costAmount;
  final String? unitId;
  final String? locationAddress;
  final double? locationLat;
  final double? locationLng;
  final String? meetingType;
  final String? imageUrl;

  final String? userFullName;
  final String? userEmail;
  final String? categoryName;
  final String? unitName;
  final String? servingTypeName;

  const ServicingEntity({
    this.id,
    required this.title,
    required this.description,
    this.categoryId,
    this.costAmount,
    this.unitId,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
    this.meetingType,
    this.imageUrl,
    this.userFullName,
    this.userEmail,
    this.categoryName,
    this.unitName,
    this.servingTypeName,
  });

  @override
  List<Object?> get props => [
    id,
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
    userFullName,
    userEmail,
    categoryName,
    unitName,
    servingTypeName,
  ];
}
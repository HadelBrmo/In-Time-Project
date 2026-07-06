// features/services/domain/entities/service_entity.dart

import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
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
  final int? userId;
  final String? userFullName;
  final String? userEmail;
  final String? categoryName;
  final String? unitName;
  final String? servingTypeName;
  final bool isRequested;
  final bool? isOwner;
  final List<dynamic>? availabilitySlots;
  final String? createdAt;

  const ServiceEntity({
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
    this.userId,
    this.userFullName,
    this.userEmail,
    this.categoryName,
    this.unitName,
    this.servingTypeName,
    this.isRequested = false,
    this.isOwner = false,
    this.availabilitySlots = const [],
    this.createdAt,
  });

  ServiceEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? categoryId,
    String? costAmount,
    String? unitId,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    String? meetingType,
    String? imageUrl,
    int? userId,
    String? userFullName,
    String? userEmail,
    String? categoryName,
    String? unitName,
    String? servingTypeName,
    bool? isRequested,
    bool? isOwner,
    List<dynamic>? availabilitySlots,
    String? createdAt,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      costAmount: costAmount ?? this.costAmount,
      unitId: unitId ?? this.unitId,
      locationAddress: locationAddress ?? this.locationAddress,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      meetingType: meetingType ?? this.meetingType,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userEmail: userEmail ?? this.userEmail,
      categoryName: categoryName ?? this.categoryName,
      unitName: unitName ?? this.unitName,
      servingTypeName: servingTypeName ?? this.servingTypeName,
      isRequested: isRequested ?? this.isRequested,
      isOwner: isOwner ?? this.isOwner,
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
    userId,
    userFullName,
    userEmail,
    categoryName,
    unitName,
    servingTypeName,
    isRequested,
    isOwner,
    availabilitySlots,
    createdAt,
  ];
}

// features/services/domain/entities/service_entity.dart - Updated

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
  final int? servingTypeId;
  final bool isRequested;
  final bool? isOwner;
  final bool? isUserVerified;
  final String? status;
  final String? reason;
  final String? score;
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
    this.servingTypeId,
    this.isRequested = false,
    this.isOwner = false,
    this.isUserVerified = false,
    this.status,
    this.reason,
    this.score,
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
    int? servingTypeId,
    bool? isRequested,
    bool? isOwner,
    bool? isUserVerified,
    String? status,
    String? reason,
    String? score,
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
      servingTypeId: servingTypeId ?? this.servingTypeId,
      isRequested: isRequested ?? this.isRequested,
      isOwner: isOwner ?? this.isOwner,
      isUserVerified: isUserVerified ?? this.isUserVerified,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      score: score ?? this.score,
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
    servingTypeId,
    isRequested,
    isOwner,
    isUserVerified,
    status,
    reason,
    score,
    availabilitySlots,
    createdAt,
  ];
}

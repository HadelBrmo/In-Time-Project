// features/requests/domain/entities/request_entity.dart
import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  final int id;
  final int servingId;
  final int requesterId;
  final String message;
  final String status;
  final String createdAt;
  final RequestServingEntity serving;

  const RequestEntity({
    required this.id,
    required this.servingId,
    required this.requesterId,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.serving,
  });

  @override
  List<Object?> get props => [id, servingId, requesterId, message, status, createdAt, serving];
}

class RequestServingEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? userFullName;
  final String? servingTypeName;
  final String? costAmount;
  final String? unitName;
  final String? categoryName;
  final String? meetingType;
  final String? locationAddress;

  const RequestServingEntity({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.userFullName,
    this.servingTypeName,
    this.costAmount,
    this.unitName,
    this.categoryName,
    this.meetingType,
    this.locationAddress,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        userFullName,
        servingTypeName,
        costAmount,
        unitName,
        categoryName,
        meetingType,
        locationAddress,
      ];
}
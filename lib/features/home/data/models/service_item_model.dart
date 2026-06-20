// features/services/data/models/service_model.dart
import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServicingEntity {
  const ServiceModel({
    super.id,
    required super.title,
    required super.description,
    required super.categoryId,
    required super.costAmount,
    super.unitId,
    required super.locationAddress,
    required super.locationLat,
    required super.locationLng,
    super.meetingType,
    super.imageUrl,
    super.userFullName,
    super.userEmail,
    super.categoryName,
    super.unitName,
    super.servingTypeName,
    super.isRequested,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'cost_amount': costAmount,
      if (unitId != null) 'unit_id': unitId!,
      'location_address': locationAddress,
      'location_lat': locationLat,
      'location_lng': locationLng,
      if (meetingType != null) 'meeting_type': meetingType!,
      if (imageUrl != null) 'image_url': imageUrl,
      'user_full_name': userFullName,
      'user_email': userEmail,
      'category_name': categoryName,
      'unit_name': unitName,
      'serving_type_name': servingTypeName,
      'requested': isRequested,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      costAmount: json['cost_amount']?.toString() ?? '0',
      unitId: json['unit_id']?.toString(),
      locationAddress: json['location_address'] ?? '',
      locationLat: json['location_lat'] != null ? double.parse(json['location_lat'].toString()) : 0.0,
      locationLng: json['location_lng'] != null ? double.parse(json['location_lng'].toString()) : 0.0,
      meetingType: json['meeting_type'],
      imageUrl: json['image_url'],
      userFullName: json['user_full_name'] ?? json['userFullName'],
      userEmail: json['user_email'] ?? json['userEmail'],
      unitName: json['unit_name'] ?? json['unitName'],
      servingTypeName: json['serving_type_name'] ?? json['servingTypeName'],
      categoryName: json['category_name'] ?? json['categoryName'],

      isRequested: json['requested'] is bool ? json['requested'] : (json['requested'] == 1),
    );
  }
}
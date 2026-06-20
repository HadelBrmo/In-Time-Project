// features/services/data/models/service_model.dart

import '../../domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    super.id,
    required super.title,
    required super.description,
    super.categoryId,
    super.costAmount,
    super.unitId,
    super.locationAddress,
    super.locationLat,
    super.locationLng,
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
      'title': title,
      'description': description,
      'category_id': categoryId,
      'cost_amount': costAmount,
      if (unitId != null) 'unit_id': unitId!,
      'location_address': locationAddress,
      'location_lat': locationLat?.toString(),
      'location_lng': locationLng?.toString(),
      if (meetingType != null) 'meeting_type': meetingType!,
      'user_email': userEmail,
      'requested': isRequested,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? json['category_name']?.toString() ?? '',
      costAmount: json['cost_amount']?.toString() ?? '0',
      unitId: json['unit_name']?.toString() ?? json['unit_id']?.toString(),
      locationAddress: json['location_address']?.toString() ?? '',
      locationLat: json['location_lat'] != null
          ? (double.tryParse(json['location_lat'].toString()) ?? 0.0)
          : 0.0,
      locationLng: json['location_lng'] != null
          ? (double.tryParse(json['location_lng'].toString()) ?? 0.0)
          : 0.0,
      meetingType: json['meeting_type']?.toString(),
      imageUrl: json['image_url']?.toString(),
      userFullName: json['user_full_name']?.toString() ?? json['userFullName'],
      userEmail: json['user_email']?.toString() ?? json['userEmail'],
      categoryName: json['category_name']?.toString() ?? json['categoryName'],
      unitName: json['unit_name']?.toString() ?? json['unitName'],
      servingTypeName: json['serving_type_name']?.toString() ?? json['servingTypeName'],
      isRequested: json['requested'] is bool ? json['requested'] : (json['requested'] == 1),
    );
  }
}

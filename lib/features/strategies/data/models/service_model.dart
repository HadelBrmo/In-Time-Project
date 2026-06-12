// features/services/data/models/service_model.dart

import '../../domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
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
    super.categoryName,
    super.unitName,
    super.servingTypeName,
  });

  Map<String, String> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
      'cost_amount': costAmount,
      if (unitId != null) 'unit_id': unitId!,
      'location_address': locationAddress,
      'location_lat': locationLat.toString(),
      'location_lng': locationLng.toString(),
      if (meetingType != null) 'meeting_type': meetingType!,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
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
      userFullName: json['user_full_name']?.toString(),
      categoryName: json['category_name']?.toString(),
      unitName: json['unit_name']?.toString(),
      servingTypeName: json['serving_type_name']?.toString(),
    );
  }
}
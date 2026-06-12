// features/services/data/models/service_model.dart

import '../../../strategies/domain/entity/service_entity.dart';

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
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      costAmount: json['cost_amount']?.toString() ?? '0',
      unitId: json['unit_name']?.toString(),
      locationAddress: json['location_address'] ?? '',
      locationLat: json['location_lat'] != null ? double.parse(json['location_lat'].toString()) : 0.0,
      locationLng: json['location_lng'] != null ? double.parse(json['location_lng'].toString()) : 0.0,
      meetingType: json['meeting_type'],
      imageUrl: json['image_url'],
    );
  }
}
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
    super.userId,
    super.userFullName,
    super.userEmail,
    super.categoryName,
    super.unitName,
    super.servingTypeName,
    super.isRequested,
    super.isOwner,
    super.status,
    super.availabilitySlots,
    super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': int.tryParse(categoryId ?? '') ?? categoryId,
      'cost_amount': int.tryParse(costAmount?.toString() ?? '0') ?? 0,
      'unit_id': int.tryParse(unitId?.toString() ?? '1') ?? 1,
      'location_address': locationAddress,
      'location_lat': locationLat,
      'location_lng': locationLng,
      if (meetingType != null) 'meeting_type': meetingType,
      if (status != null) 'status': status,
      if (servingTypeId != null) 'serving_type_id': servingTypeId,
      'serving_type_name': servingTypeName,
      'unit_name': unitName,
      'category_name': categoryName,
      'user_full_name': userFullName,
      'image_url': imageUrl,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'] ?? json['serving_id'];
    
    String? typeName;
    if (json['serving_type_name'] != null) {
      typeName = json['serving_type_name'].toString();
    } else if (json['serving_type'] is Map) {
      typeName = json['serving_type']['name']?.toString();
    } else if (json['servingTypeName'] != null) {
      typeName = json['servingTypeName'].toString();
    }

    return ServiceModel(
      id: idValue is int ? idValue : int.tryParse(idValue?.toString() ?? ''),
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
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      userFullName: json['user_full_name']?.toString() ?? json['userFullName'],
      userEmail: json['user_email']?.toString() ?? json['userEmail'],
      categoryName: json['category_name']?.toString() ?? json['categoryName'],
      unitName: json['unit_name']?.toString() ?? json['unitName'],
      servingTypeName: typeName,
      isRequested: json['requested'] is bool ? json['requested'] : (json['requested'] == 1),
      isOwner: json['isOwner'] ?? json['is_owner'] ?? false,
      status: json['status']?.toString(),
      availabilitySlots: json['availability_slots'] ?? json['availabilitySlots'] ?? [],
      createdAt: json['created_at']?.toString(),
    );
  }
}


import '../../../servings/domain/entity/service_entity.dart';

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
    super.reason,
    super.score,
    super.createdAt,
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
      'user_id': userId,
      'user_full_name': userFullName,
      'user_email': userEmail,
      'category_name': categoryName,
      'unit_name': unitName,
      'serving_type_name': servingTypeName,
      'requested': isRequested,
      'isOwner': isOwner,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (score != null) 'score': score,
      'created_at': createdAt,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] is Map ? json['user'] : null;
    final userIdValue = json['user_id'] ?? userJson?['id'];

    return ServiceModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',

      costAmount: json['cost_amount']?.toString() ?? '0',
      unitId: json['unit_id']?.toString(),
      locationAddress: json['location_address'] ?? '',

      locationLat: json['location_lat'] != null ? double.tryParse(json['location_lat'].toString()) : 0.0,
      locationLng: json['location_lng'] != null ? double.tryParse(json['location_lng'].toString()) : 0.0,

      meetingType: json['meeting_type'],
      imageUrl: json['image_url'],
      userId: userIdValue is int ? userIdValue : int.tryParse(userIdValue?.toString() ?? ''),
      userFullName: json['user_full_name'] ?? json['userFullName'] ?? userJson?['full_name'],
      userEmail: json['user_email'] ?? json['userEmail'] ?? userJson?['email'],
      unitName: json['unit_name'] ?? json['unitName'],
      servingTypeName: json['serving_type_name'] ?? json['servingTypeName'],
      categoryName: json['category_name'] ?? json['categoryName'],

      isRequested: json['requested'] is bool ? json['requested'] : (json['requested'] == 1 || json['requested'] == true),
      isOwner: json['isOwner'] is bool ? json['isOwner'] : (json['isOwner'] == 1 || json['isOwner'] == true),
      status: json['status']?.toString(),
      reason: json['reason']?.toString(),
      score: json['score']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

import '../../domain/entity/request_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.servingId,
    required super.requesterId,
    required super.message,
    required super.status,
    required super.createdAt,
    required super.serving,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      servingId: json['serving_id'] is int ? json['serving_id'] : int.tryParse(json['serving_id']?.toString() ?? '') ?? 0,
      requesterId: json['requester_id'] is int ? json['requester_id'] : int.tryParse(json['requester_id']?.toString() ?? '') ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      serving: RequestServingModel.fromJson(json['serving'] ?? {}),
    );
  }
}

class RequestServingModel extends RequestServingEntity {
  const RequestServingModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
    super.userFullName,
    super.servingTypeName,
    super.costAmount,
    super.unitName,
    super.categoryName,
    super.meetingType,
    super.locationAddress,
  });

  factory RequestServingModel.fromJson(Map<String, dynamic> json) {
    String? inferredTypeName = json['serving_type_name']?.toString() ??
        json['servingTypeName']?.toString() ??
        json['serving_type']?['name']?.toString();

    if (inferredTypeName == null && json['serving_type_id'] != null) {
      final typeId = int.tryParse(json['serving_type_id'].toString());
      if (typeId == 1) inferredTypeName = "paid";
      if (typeId == 2) inferredTypeName = "barter";
    }

    String? inferredUnitName = json['unit_name']?.toString() ??
        json['unitName']?.toString() ??
        json['unit']?['name']?.toString();

    if (inferredUnitName == null && json['unit_id'] != null) {
      final unitId = int.tryParse(json['unit_id'].toString());
      if (unitId == 1) inferredUnitName = "USD";
      if (unitId == 2) inferredUnitName = "SYP";
    }

    String? inferredUserName = json['user_full_name']?.toString() ??
        json['user_name']?.toString() ??
        json['user']?['full_name']?.toString() ??
        json['user']?['name']?.toString();

    if (inferredUserName == null || inferredUserName.isEmpty) {
      inferredUserName = "مقدم الخدمة رقم (${json['user_id'] ?? ''})";
    }

    return RequestServingModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      userFullName: inferredUserName,
      servingTypeName: inferredTypeName ?? "paid",
      costAmount: json['cost_amount']?.toString() ?? json['cost']?.toString() ?? '0',
      unitName: inferredUnitName ?? "USD",
      categoryName: json['category_name']?.toString() ?? json['category']?['name']?.toString(),
      meetingType: json['meeting_type']?.toString() ?? "online",
      locationAddress: json['location_address']?.toString() ?? "دمشق، سوريا",
    );
  }
}
// lib/features/my_servings/data/model/my_serving_model.dart
import '../../domain/entity/my_serving_entity.dart';

class MyServingModel extends MyServingEntity {
  MyServingModel({
    required super.id,
    required super.title,
    required super.description,
    required super.costAmount,
    super.imageUrl,
    required super.meetingType,
    required super.createdAt,
    required super.servingTypeName,
    required super.unitName,
  });


  factory MyServingModel.fromJson(Map<String, dynamic> json) {
    return MyServingModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      costAmount: (json['cost_amount'] as num? ?? 0).toDouble(),
      imageUrl: json['image_url'],
      meetingType: json['meeting_type'] ?? 'direct',

      createdAt: json['created_at'] ?? '',
      servingTypeName: json['serving_type_name'] ?? 'paid',
      unitName: json['unit_name'] ?? 'ل.س',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'cost_amount': costAmount,
      'meeting_type': meetingType,
    };
  }
}
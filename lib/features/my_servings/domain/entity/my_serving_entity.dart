// lib/features/my_servings/domain/entity/my_serving_entity.dart

class MyServingEntity {
  final int id;
  final String title;
  final String description;
  final double costAmount;
  final String? imageUrl;
  final String meetingType;
  final String createdAt;
  final String servingTypeName;
  final String unitName;
  final bool? isOwner;

  MyServingEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.costAmount,
    this.imageUrl,
    required this.meetingType,
    required this.createdAt,
    required this.servingTypeName,
    required this.unitName,
    this.isOwner= false,
  });
}
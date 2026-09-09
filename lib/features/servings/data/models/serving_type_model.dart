import '../../domain/entity/serving_type_entity.dart';

class ServingTypeModel extends ServingTypeEntity {
  const ServingTypeModel({required super.id, required super.name});

  factory ServingTypeModel.fromJson(Map<String, dynamic> json) {
    return ServingTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

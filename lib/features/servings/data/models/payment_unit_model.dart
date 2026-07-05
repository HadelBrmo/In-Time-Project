import '../../domain/entity/payment_unit_entity.dart';

class PaymentUnitModel extends PaymentUnitEntity {
  const PaymentUnitModel({required super.id, required super.name});

  factory PaymentUnitModel.fromJson(Map<String, dynamic> json) {
    return PaymentUnitModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

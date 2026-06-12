import 'package:equatable/equatable.dart';

class PaymentUnitEntity extends Equatable {
  final int id;
  final String name;

  const PaymentUnitEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

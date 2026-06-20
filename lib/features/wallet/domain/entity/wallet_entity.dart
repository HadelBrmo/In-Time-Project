import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final int id;
  final int userId;
  final String title;
  final double balance;
  final String unitName;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.balance,
    required this.unitName,
  });

  @override
  List<Object?> get props => [id, userId, title, balance, unitName];
}
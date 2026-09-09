import '../../domain/entity/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.balance,
    required super.unitName,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      unitName: json['unit'] != null ? json['unit']['name'] as String : 'Hour',
    );
  }
}
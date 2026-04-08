import 'package:flutter/material.dart';

class HoursBalanceCard extends StatelessWidget {
  final int balance;

  const HoursBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Hours Balance: $balance'),
      ),
    );
  }
}
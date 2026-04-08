import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final String name;
  final int cost;

  const RewardCard({required this.name, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Cost: $cost hours'),
      ),
    );
  }
}
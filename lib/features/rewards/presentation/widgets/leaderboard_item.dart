import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  final String name;
  final int hours;
  final int rank; // Gold/Silver/Bronze

  const LeaderboardItem({required this.name, required this.hours, required this.rank});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('#$rank'),
      title: Text(name),
      trailing: Text('$hours hours'),
    );
  }
}
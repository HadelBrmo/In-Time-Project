import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final String description;

  const BadgeCard({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
      ),
    );
  }
}
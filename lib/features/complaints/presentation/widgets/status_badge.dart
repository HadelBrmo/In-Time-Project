import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status; // منجزة/قيد المعالجة/مرفوضة

  const StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'منجزة':
        color = Colors.green;
        break;
      case 'قيد المعالجة':
        color = Colors.yellow;
        break;
      case 'مرفوضة':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status),
      backgroundColor: color,
    );
  }
}
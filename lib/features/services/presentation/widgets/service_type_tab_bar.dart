import 'package:flutter/material.dart';

class ServiceTypeTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(text: 'تبادلية'),
        Tab(text: 'مدفوعة'),
        Tab(text: 'تطوعية'),
      ],
    );
  }
}
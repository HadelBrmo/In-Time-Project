import 'package:flutter/material.dart';

class MyHoursPage extends StatelessWidget {
  // رصيد ساعاتك + Progress Bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Hours')),
      body: Center(child: Text('My Hours Page')),
    );
  }
}
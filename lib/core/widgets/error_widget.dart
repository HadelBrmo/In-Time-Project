import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;

  const ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text('Error: $message');
  }
}
import 'package:flutter/material.dart';

class PriceInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(hintText: 'Price'),
    );
  }
}
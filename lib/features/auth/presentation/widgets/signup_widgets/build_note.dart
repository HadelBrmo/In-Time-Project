import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildNote(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    ),
  );
}
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String bio;

  const ProfileHeader({required this.name, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 24)),
        Text(bio),
      ],
    );
  }
}
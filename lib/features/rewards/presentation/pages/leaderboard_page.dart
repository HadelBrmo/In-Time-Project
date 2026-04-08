import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  // لوحة الشرف (Top 5)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: Center(child: Text('Leaderboard Page')),
    );
  }
}
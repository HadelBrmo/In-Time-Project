import 'package:flutter/material.dart';
import 'package:in_time/features/strategies_services/presentation/pages/services/paid_strategy.dart';

class VoluntaryServicePage extends StatelessWidget {
  const VoluntaryServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaidServicePage(
      isBarter: false,
      isVoluntary: true,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:in_time/features/strategies_services/presentation/pages/services/paid_strategy.dart';

class BarterStrategyPage extends StatelessWidget {
  const BarterStrategyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaidServicePage(
      isBarter: true,
      isVoluntary: false,
    );
  }
}
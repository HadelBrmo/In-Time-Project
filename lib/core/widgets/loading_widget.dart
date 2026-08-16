import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;

  const LoadingWidget({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final defaultSize = mediaQuery.size.width * 0.25;

    return Center(
      child: SizedBox(
        width: size ?? defaultSize,
        height: size ?? defaultSize,
        child: Lottie.asset(
          'assets/animations/smooth-triple-dot-loading.lottie',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
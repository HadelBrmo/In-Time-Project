import 'package:flutter/cupertino.dart';

Widget buildAnimatedItem({required Widget child, required int delayFactor}) {
  return TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: Duration(milliseconds: 350 + (delayFactor * 120)),
    curve: Curves.ease,
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 25 * (1.0 - value)),
          child: child,
        ),
      );
    },
    child: child,
  );
}
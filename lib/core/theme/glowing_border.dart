import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlowingBorder extends StatefulWidget {
  final Widget child;
  final List<Color> glowColors;
  final double borderRadius;
  final double strokeWidth;
  final BoxShape shape;

  const GlowingBorder({
    super.key,
    required this.child,
    this.glowColors = const [Colors.purple, Colors.blue, Colors.cyan, Colors.purple],
    this.borderRadius = 15.0,
    this.strokeWidth = 2.5,
    this.shape = BoxShape.rectangle,
  });

  @override
  State<GlowingBorder> createState() => _GlowingBorderState();
}

class _GlowingBorderState extends State<GlowingBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlowPainter(
            angle: _controller.value * 2 * math.pi,
            colors: widget.glowColors,
            radius: widget.borderRadius,
            strokeWidth: widget.strokeWidth,
            shape: widget.shape,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.strokeWidth / 2),
            child: child,
          ),
        );
      },
      child: widget.shape == BoxShape.circle
          ? ClipOval(child: widget.child)
          : ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: widget.child,
            ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final double angle;
  final List<Color> colors;
  final double radius;
  final double strokeWidth;
  final BoxShape shape;

  _GlowPainter({
    required this.angle,
    required this.colors,
    required this.radius,
    required this.strokeWidth,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        colors: colors,
        transform: GradientRotation(angle),
      ).createShader(rect);

    final shadowPaint = Paint()
      ..strokeWidth = strokeWidth * 3
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        colors: colors,
        transform: GradientRotation(angle),
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, size.width / 2, shadowPaint);
      canvas.drawCircle(rect.center, size.width / 2, paint);
    } else {
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rrect, shadowPaint);
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(_GlowPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.colors != colors;
}
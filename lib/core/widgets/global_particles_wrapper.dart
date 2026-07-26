import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/settings_state.dart';
import '../constants/app_colors.dart';

class GlobalParticlesWrapper extends StatefulWidget {
  final Widget child;

  const GlobalParticlesWrapper({super.key, required this.child});

  @override
  State<GlobalParticlesWrapper> createState() => _GlobalParticlesWrapperState();
}

class _GlobalParticlesWrapperState extends State<GlobalParticlesWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  final List<_ParticleModel> _particles = [];
  final Random _random = Random();
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      if (mounted) setState(() {});
    })..repeat();
  }

  void _initializeParticles(Size size) {
    _particles.clear();
    for (int i = 0; i < 45; i++) {
      _particles.add(_ParticleModel(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        size: _random.nextDouble() * 2.0 + 1.0,
        speed: _random.nextDouble() * 0.4 + 0.1,
        isAlternativeColor: _random.nextBool(),
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (!settingsState.animationsEnabled) {
          if (_particleController.isAnimating) {
            _particleController.stop();
          }
          return widget.child;
        } else {
          if (!_particleController.isAnimating) {
            _particleController.repeat();
          }
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);

            if (_lastSize != size) {
              _lastSize = size;
              _initializeParticles(size);
            }

            for (var particle in _particles) {
              particle.y -= particle.speed;
              if (particle.y < 0) {
                particle.y = size.height;
                particle.x = _random.nextDouble() * size.width;
              }
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _ParticlePainter(particles: _particles, isDarkMode: isDarkMode),
                    ),
                  ),
                ),
                widget.child,
              ],
            );
          },
        );
      },
    );
  }
}

class _ParticleModel {
  double x;
  double y;
  final double size;
  final double speed;
  final bool isAlternativeColor;

  _ParticleModel({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.isAlternativeColor,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleModel> particles;
  final bool isDarkMode;

  _ParticlePainter({required this.particles, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var particle in particles) {
      if (isDarkMode) {
        paint.color = Colors.white.withOpacity(0.25);
      } else {
        paint.color = particle.isAlternativeColor
            ? AppColors.primaryColor.withOpacity(0.25)
            : AppColors.darkGreyColor.withOpacity(0.20);
      }
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

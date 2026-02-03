import 'dart:math';
import 'package:flutter/material.dart';

class SuccessBackground extends StatefulWidget {
  final Widget child;
  const SuccessBackground({super.key, required this.child});

  @override
  State<SuccessBackground> createState() => _SuccessBackgroundState();
}

class _SuccessBackgroundState extends State<SuccessBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 50; i++) {
      _particles.add(_generateParticle());
    }
  }

  Particle _generateParticle() {
    return Particle(
      x: _random.nextDouble(), // 0.0 to 1.0 (screen width)
      y: _random.nextDouble(), // 0.0 to 1.0 (screen height)
      speed: 0.1 + _random.nextDouble() * 0.2,
      size: 5.0 + _random.nextDouble() * 10.0,
      angle: _random.nextDouble() * 2 * pi,
      color: Colors.white.withValues(alpha: 0.1 + _random.nextDouble() * 0.3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
        // Particle Animation
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(_particles, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double angle;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.angle,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      // Move particle up
      particle.y -= particle.speed * 0.01;

      // Reset if goes off top
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = Random().nextDouble();
      }

      paint.color = particle.color;
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

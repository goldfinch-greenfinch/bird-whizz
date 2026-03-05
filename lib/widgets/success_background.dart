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
    final colors = const [
      Colors.yellowAccent,
      Colors.lightGreenAccent,
      Color(0xFFE6EE9C), // Lime
      Color(0xFFFFE082), // Amber
    ];

    return Particle(
      x: _random.nextDouble(), // 0.0 to 1.0 (screen width)
      y: _random.nextDouble(), // 0.0 to 1.0 (screen height)
      speed: 0.05 + _random.nextDouble() * 0.15, // Slightly slower speed
      size: 2.0 + _random.nextDouble() * 5.0, // Slightly smaller size
      angle: _random.nextDouble() * 2 * pi,
      color: colors[_random.nextInt(colors.length)],
      pulseOffset: _random.nextDouble() * 2 * pi, // Random phase
      maxAlpha: 0.3 + _random.nextDouble() * 0.7, // Random peak brightness
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
              // Dark twilight forest / midnight blue nature gradient
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
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
  double pulseOffset;
  double maxAlpha;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.angle,
    required this.color,
    required this.pulseOffset,
    required this.maxAlpha,
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

      // Add slight horizontal drift for floating effect
      particle.x += sin(animationValue * 2 * pi + particle.pulseOffset) * 0.001;

      // Reset if goes off top
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = Random().nextDouble();
      }

      // Pulsing opacity effect using sine wave based on animation value
      // animationValue goes from 0.0 to 1.0
      double pulse =
          (sin((animationValue * 2 * pi * 3.0) + particle.pulseOffset) + 1.0) /
          2.0;
      double currentAlpha = 0.1 + (pulse * particle.maxAlpha);
      currentAlpha = currentAlpha.clamp(0.0, 1.0);

      paint.color = particle.color.withValues(alpha: currentAlpha);

      // Subtle glow effect
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

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

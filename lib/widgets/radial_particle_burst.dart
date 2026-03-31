import 'dart:math';
import 'package:flutter/material.dart';

class RadialParticleBurst extends StatelessWidget {
  final Animation<double> animation;
  final List<Color> colors;
  final int particleCount;
  final List<_RadialParticle> _particles;

  RadialParticleBurst({
    super.key,
    required this.animation,
    this.colors = const [
      Colors.white,
      Colors.amber,
      Colors.orange,
      Colors.yellow,
      Colors.tealAccent,
      Color(0xFFFFD700),
    ],
    this.particleCount = 180,
  }) : _particles = _generateParticles(particleCount, colors);

  static List<_RadialParticle> _generateParticles(
    int count,
    List<Color> colors,
  ) {
    final random = Random();
    return List.generate(count, (index) {
      // Mix of shapes: ovals (feathers) and circles (sparks)
      final isCircle = index % 4 == 0;
      return _RadialParticle(
        angle: random.nextDouble() * 2 * pi,
        speed: 80 + random.nextDouble() * 350,
        size: isCircle
            ? (4 + random.nextDouble() * 7)
            : (2 + random.nextDouble() * 6),
        color: colors[random.nextInt(colors.length)],
        spinSpeed: (random.nextDouble() - 0.5) * 12 * pi,
        isCircle: isCircle,
        // Stagger the start of each particle slightly
        delay: random.nextDouble() * 0.15,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          if (animation.value == 0) return const SizedBox.shrink();
          return CustomPaint(
            painter: _RadialBurstPainter(_particles, animation.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _RadialParticle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double spinSpeed;
  final bool isCircle;
  final double delay;

  _RadialParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.spinSpeed,
    required this.isCircle,
    required this.delay,
  });
}

class _RadialBurstPainter extends CustomPainter {
  final List<_RadialParticle> particles;
  final double progress;

  _RadialBurstPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (var p in particles) {
      // Apply per-particle delay
      final localProgress = ((progress - p.delay) / (1.0 - p.delay))
          .clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      // Ease out distance: fast at first, then slow down
      final distance = p.speed * Curves.easeOutQuart.transform(localProgress);

      // Add gravity-like droop for feather particles
      final gravityY = p.isCircle ? 0.0 : localProgress * localProgress * 40;

      final x = center.dx + cos(p.angle) * distance;
      final y = center.dy + sin(p.angle) * distance + gravityY;

      // Fade out towards the end, stay bright longer
      final opacity = 1.0 - Curves.easeIn.transform(
        (localProgress - 0.4).clamp(0.0, 1.0) / 0.6,
      );
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = p.color.withAlpha((opacity * 255).toInt())
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spinSpeed * localProgress);

      if (p.isCircle) {
        // Spark: circle
        canvas.drawCircle(Offset.zero, p.size, paint);
        // Add a bright white glow dot at center
        final glowPaint = Paint()
          ..color = Colors.white.withAlpha((opacity * 180).toInt())
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, p.size * 0.4, glowPaint);
      } else {
        // Feather: slender oval
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 3.0,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _RadialBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

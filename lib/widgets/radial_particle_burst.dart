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
      Colors.tealAccent,
    ],
    this.particleCount = 120, // More particles for a good explosion
  }) : _particles = _generateParticles(particleCount, colors);

  static List<_RadialParticle> _generateParticles(
    int count,
    List<Color> colors,
  ) {
    final random = Random();
    return List.generate(count, (index) {
      return _RadialParticle(
        angle: random.nextDouble() * 2 * pi,
        speed: 100 + random.nextDouble() * 250, // Explosive speed
        size: 3 + random.nextDouble() * 6, // Feathers/particles
        color: colors[random.nextInt(colors.length)],
        spinSpeed: (random.nextDouble() - 0.5) * 8 * pi,
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

  _RadialParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.spinSpeed,
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
      // Ease out distance: fast at first, then slow down
      final distance = p.speed * Curves.easeOutQuart.transform(progress);

      final x = center.dx + cos(p.angle) * distance;
      final y = center.dy + sin(p.angle) * distance;

      // Fade out towards the end
      final opacity = 1.0 - Curves.easeIn.transform(progress);
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = p.color.withAlpha((opacity * 255).toInt())
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spinSpeed * progress);

      // Draw feather-like shape (slender oval)
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 2.5,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _RadialBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

class ParticleOverlay extends StatefulWidget {
  final List<Color> colors;
  final int numberOfParticles;

  const ParticleOverlay({
    super.key,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ],
    this.numberOfParticles = 50,
  });

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ), // Ticker duration, loop acts as tick
    )..repeat();
    _particles = List.generate(
      widget.numberOfParticles,
      (index) => _createParticle(startRandomY: true),
    );
  }

  Particle _createParticle({bool startRandomY = false}) {
    return Particle(
      x: _random.nextDouble(),
      y: startRandomY
          ? -1.0 + _random.nextDouble() * 2.0
          : -0.2, // Start random or just above
      speed: 0.002 + _random.nextDouble() * 0.008,
      size: 6 + _random.nextDouble() * 8,
      color: widget.colors[_random.nextInt(widget.colors.length)],
      angle: _random.nextDouble() * 2 * pi,
      spinSpeed: (_random.nextDouble() - 0.5) * 0.1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(_particles, _random, (particle) {
              // Update logic inside painter? No, update here
              particle.y += particle.speed;
              particle.angle += particle.spinSpeed;
              if (particle.y > 1.1) {
                // Reset to top
                particle.y = -0.1;
                particle.x = _random.nextDouble();
                particle.speed = 0.002 + _random.nextDouble() * 0.008;
              }
            }),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  Color color;
  double angle;
  double spinSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
    required this.angle,
    required this.spinSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Random random;
  final Function(Particle) onUpdate;

  ParticlePainter(this.particles, this.random, this.onUpdate);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      onUpdate(p); // Update position
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.angle);

      // Draw simple rectangle for confetti
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

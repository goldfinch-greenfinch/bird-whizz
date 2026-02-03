import 'dart:math';
import 'package:flutter/material.dart';

// --- Shake Widget ---
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double deltaX;
  final Curve curve;
  final VoidCallback? onAnimationComplete;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    this.onAnimationComplete,
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: widget.curve)).animate(_controller);

    if (widget.onAnimationComplete != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete!();
          _controller.reset();
        }
      });
    }
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        final sineValue = sin(4 * pi * _offsetAnimation.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.deltaX, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// --- Confetti / Fireworks Overlay ---
class ConfettiOverlay extends StatefulWidget {
  final Widget child;

  const ConfettiOverlay({super.key, required this.child});

  @override
  ConfettiOverlayState createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
  }

  void burst() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(_Particle(_random));
    }
    _controller.forward(from: 0.0);
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
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ConfettiPainter(_particles)),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late Color color;
  late double size;

  _Particle(Random random) {
    x = 0.5; // Start center (normalized 0..1)
    y = 0.5;
    double angle = random.nextDouble() * 2 * pi;
    double speed = random.nextDouble() * 0.02 + 0.01;
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    size = random.nextDouble() * 5 + 3;

    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    color = colors[random.nextInt(colors.length)];
  }

  void update() {
    x += vx;
    y += vy;
    vy += 0.001; // Gravity (normalized)

    // Simple drag could be added if needed, but not necessary for simple burst
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()..color = particle.color;
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

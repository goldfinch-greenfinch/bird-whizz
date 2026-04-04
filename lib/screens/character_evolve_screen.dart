import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import '../router/app_router.dart';
import '../widgets/navigation_utils.dart';
import '../services/audio_service.dart';

// ─── Stage Names ──────────────────────────────────────────────────────────────
const List<String> _stageNames = [
  'Egg',
  'Hatchling',
  'Fledgling',
  'Adult',
  'Magnificent',
];

String _stageName(int stage) => _stageNames[stage.clamp(1, 5) - 1];

// ─── Colours ──────────────────────────────────────────────────────────────────
const _bgDark = Color(0xFF0A0A1A);
const _bgMid = Color(0xFF0D2040);
const Color _gold = Color(0xFFFFD700);
const Color _amber = Color(0xFFFFAB00);
const Color _tealLight = Color(0xFF80CBC4);

// ─── Screen ───────────────────────────────────────────────────────────────────
class CharacterEvolveScreen extends StatefulWidget {
  const CharacterEvolveScreen({super.key});

  @override
  State<CharacterEvolveScreen> createState() => _CharacterEvolveScreenState();
}

class _CharacterEvolveScreenState extends State<CharacterEvolveScreen>
    with TickerProviderStateMixin {
  // ── Phase timeline  (total 5 000 ms) ──────────────────────────────────────
  // Phase 1 – intro          0.00 → 0.18   (900 ms)
  // Phase 2 – build-up       0.18 → 0.52   (1 700 ms)
  // Phase 3 – flash          0.52 → 0.65   (650 ms)
  // Phase 4 – reveal         0.65 → 0.82   (850 ms)
  // Phase 5 – celebration    0.82 → 1.00   (900 ms)
  // ────────────────────────────────────────────────────────────────────────────

  late final AnimationController _main;

  // Looping controllers
  late final AnimationController _pulse; // bg glow pulse during build-up
  late final AnimationController _sparkle; // orbiting sparkles loop
  late final AnimationController _confetti; // confetti rain loop

  // ── Derived animations ────────────────────────────────────────────────────
  late final Animation<double> _introBgFade;  // bg dark fade-in
  late final Animation<double> _introTitleScale; // "YOU ARE EVOLVING!"
  late final Animation<double> _introTitleFade;
  late final Animation<double> _oldBirdSlideIn; // old bird rises into view
  late final Animation<double> _shake;      // grow intensity shake
  late final Animation<double> _glowScale;  // glow behind bird
  late final Animation<double> _glowFade;
  late final Animation<double> _ringAnim;   // energy rings
  late final Animation<double> _flashAnim;  // white flash
  late final Animation<double> _oldBirdFade; // old bird disappears
  late final Animation<double> _newBirdPop; // new bird elastic pop
  late final Animation<double> _fireworks;  // fireworks visible
  late final Animation<double> _revealTitle; // "YOU EVOLVED!"
  late final Animation<double> _celebration; // celebration fade-in

  // ── Confetti / firework data (generated once) ───────────────────────────
  late final List<_ConfettiPiece> _confettiPieces;
  late final List<_FireworkBurst> _fireworkBursts;

  // Track whether we are past the flash so we can switch which bird to show
  bool get _isPostFlash => _main.value >= 0.62;

  @override
  void initState() {
    super.initState();
    final rng = Random(7);

    _confettiPieces = List.generate(
      200,
      (i) => _ConfettiPiece(
        x: rng.nextDouble(),
        speed: 0.18 + rng.nextDouble() * 0.55,
        delay: rng.nextDouble() * 0.6,
        width: 6 + rng.nextDouble() * 10,
        height: 4 + rng.nextDouble() * 7,
        angle: rng.nextDouble() * 2 * pi,
        spin: (rng.nextDouble() - 0.5) * 8 * pi,
        color: [
          _gold,
          _amber,
          Colors.pinkAccent,
          const Color(0xFF69F0AE),
          const Color(0xFF40C4FF),
          Colors.white,
          Colors.orange,
        ][rng.nextInt(7)],
      ),
    );

    _fireworkBursts = List.generate(
      6,
      (i) => _FireworkBurst(
        x: 0.1 + rng.nextDouble() * 0.8,
        y: 0.05 + rng.nextDouble() * 0.45,
        delay: rng.nextDouble() * 0.4,
        color: [
          _gold,
          Colors.pinkAccent,
          const Color(0xFF69F0AE),
          Colors.white,
          _amber,
          const Color(0xFF40C4FF),
        ][i % 6],
        particleCount: 16 + rng.nextInt(12),
        radius: 60 + rng.nextDouble() * 80,
      ),
    );

    // ── Main timeline (5 000 ms) ────────────────────────────────────────────
    _main = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Looping controllers
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _sparkle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _confetti = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // ── Animations ───────────────────────────────────────────────────────────
    _introBgFade = _interval(0.00, 0.12, curve: Curves.easeOut);

    _introTitleScale = Tween<double>(begin: 2.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.04, 0.16, curve: Curves.elasticOut),
      ),
    );
    _introTitleFade = _interval(0.04, 0.14, curve: Curves.easeOut);

    _oldBirdSlideIn = _interval(0.10, 0.22, curve: Curves.easeOutBack);

    _shake = _interval(0.18, 0.52, curve: Curves.easeIn);

    _glowScale = Tween<double>(begin: 0.0, end: 3.8).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.18, 0.52, curve: Curves.easeIn),
      ),
    );
    _glowFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.52, 0.66, curve: Curves.easeIn),
      ),
    );

    _ringAnim = _interval(0.28, 0.54, curve: Curves.easeOut);

    // Flash: ramp up 0.52→0.58, ramp down 0.58→0.68
    _flashAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 37),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 63),
    ]).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.52, 0.70, curve: Curves.linear),
      ),
    );

    _oldBirdFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.52, 0.60, curve: Curves.easeIn),
      ),
    );

    _newBirdPop = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.63, 0.80, curve: Curves.elasticOut),
      ),
    );

    _fireworks = _interval(0.64, 1.00, curve: Curves.easeOut);

    _revealTitle = _interval(0.78, 0.92, curve: Curves.easeOut);

    _celebration = _interval(0.82, 0.98, curve: Curves.easeOut);

    // ── Start sequence ───────────────────────────────────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audio = context.read<AudioService>();
      audio.playMenuMusic();

      // Level-up sound at the flash
      Future.delayed(const Duration(milliseconds: 2600), () {
        if (mounted) audio.playLevelUpSound();
      });

      // Short pause then roll
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _main.forward();
      });
    });
  }

  Animation<double> _interval(
    double begin,
    double end, {
    Curve curve = Curves.linear,
  }) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _main,
          curve: Interval(begin, end, curve: curve),
        ),
      );

  @override
  void dispose() {
    _main.dispose();
    _pulse.dispose();
    _sparkle.dispose();
    _confetti.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: NavigationUtils.buildBackButton(context, color: Colors.white),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, _) {
          Bird? bird;
          if (provider.selectedBirdId != null) {
            try {
              bird = availableBirds.firstWhere(
                (b) => b.id == provider.selectedBirdId,
              );
            } catch (_) {}
          }
          if (bird == null) {
            return const Center(
              child: Text('Bird not found', style: TextStyle(color: Colors.white)),
            );
          }

          final oldStage = provider.oldEvolutionStage ?? 1;
          final newStage = provider.newEvolutionStage ?? 2;
          final oldName = _stageName(oldStage);
          final newName = _stageName(newStage);
          final b = bird; // non-nullable alias

          return AnimatedBuilder(
            animation: Listenable.merge(
              [_main, _pulse, _sparkle, _confetti],
            ),
            builder: (context, _) {
              final isPostFlash = _isPostFlash;

              return Stack(
                children: [
                  // ── 0. Background ─────────────────────────────────────────
                  _Background(
                    introBgFade: _introBgFade.value,
                    mainProgress: _main.value,
                    pulse: _pulse.value,
                  ),

                  // ── 1. Energy rings (build-up) ────────────────────────────
                  if (!isPostFlash)
                    _EnergyRings(progress: _ringAnim.value),

                  // ── 2. Orbiting sparkles (build-up only) ──────────────────
                  if (!isPostFlash && _main.value > 0.18)
                    _OrbitSparkles(
                      buildProgress: (_main.value - 0.18) / 0.34,
                      sparkleT: _sparkle.value,
                    ),

                  // ── 3. Fireworks (reveal phase) ────────────────────────────
                  if (isPostFlash)
                    _Fireworks(
                      bursts: _fireworkBursts,
                      progress: _fireworks.value,
                    ),

                  // ── 4. Confetti rain (celebration) ────────────────────────
                  if (isPostFlash)
                    _ConfettiRain(
                      pieces: _confettiPieces,
                      loopT: _confetti.value,
                      celebrationProgress: _celebration.value,
                    ),

                  // ── 5. White flash overlay ─────────────────────────────────
                  if (_flashAnim.value > 0)
                    Opacity(
                      opacity: _flashAnim.value,
                      child: Container(color: Colors.white),
                    ),

                  // ── 6. Main foreground content ─────────────────────────────
                  SafeArea(
                    child: _buildContent(
                      b, oldStage, newStage, oldName, newName, isPostFlash, provider,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildContent(
    Bird bird,
    int oldStage,
    int newStage,
    String oldName,
    String newName,
    bool isPostFlash,
    QuizProvider qp,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // ── Top title (switches between phases) ─────────────────────────────
        SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // "YOU ARE EVOLVING!" – intro phase
              if (!isPostFlash)
                Opacity(
                  opacity: _introTitleFade.value,
                  child: Transform.scale(
                    scale: _introTitleScale.value,
                    child: _GlowText(
                      'YOU ARE EVOLVING!',
                      fontSize: 28,
                      color: _tealLight,
                      glowColor: _tealLight,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),

              // "YOU EVOLVED!" – celebration phase (cross-fades in)
              if (isPostFlash)
                Opacity(
                  opacity: _revealTitle.value,
                  child: Transform.scale(
                    scale: 0.6 + _revealTitle.value * 0.4,
                    child: _GlowText(
                      'YOU EVOLVED!',
                      fontSize: 36,
                      color: _gold,
                      glowColor: _gold,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ── Stage labels (appear in celebration) ────────────────────────────
        AnimatedOpacity(
          opacity: isPostFlash ? _celebration.value : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - _celebration.value)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StageChip(label: oldName, color: _tealLight, bold: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: _amber, size: 22),
                ),
                _StageChip(label: newName, color: _gold, bold: true),
              ],
            ),
          ),
        ),

        const Spacer(),

        // ── Bird animation area ──────────────────────────────────────────────
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow orb behind bird
              if (!isPostFlash && _glowScale.value > 0)
                Opacity(
                  opacity: isPostFlash ? 0 : _glowFade.value,
                  child: Transform.scale(
                    scale: _glowScale.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFFFF59D),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

              // Old bird (visible before flash)
              if (!isPostFlash)
                _OldBird(
                  imagePath: bird.getEvolvedImagePath(oldStage),
                  slideProgress: _oldBirdSlideIn.value,
                  fadeOut: _oldBirdFade.value,
                  shake: _shake.value,
                ),

              // New bird (pops in after flash)
              if (isPostFlash)
                _NewBird(
                  imagePath: bird.getEvolvedImagePath(newStage),
                  popProgress: _newBirdPop.value,
                ),
            ],
          ),
        ),

        const Spacer(),

        // ── Before/After thumbnail strip ─────────────────────────────────────
        AnimatedOpacity(
          opacity: isPostFlash ? _celebration.value : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BirdThumb(
                  imagePath: bird.getEvolvedImagePath(oldStage),
                  label: oldName,
                  accent: _tealLight,
                  dimmed: true,
                ),
                const SizedBox(width: 20),
                Icon(Icons.arrow_forward_rounded, color: _amber, size: 32),
                const SizedBox(width: 20),
                _BirdThumb(
                  imagePath: bird.getEvolvedImagePath(newStage),
                  label: newName,
                  accent: _gold,
                  dimmed: false,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ── Continue button ───────────────────────────────────────────────────
        AnimatedOpacity(
          opacity: _main.value >= 1.0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _main.value >= 1.0
                     ? () {
                        if (kDebugMode && qp.hasDebugEvolveQueued) {
                          qp.debugAdvanceEvolveQueue();
                          context.pushReplacement(AppRoutes.evolve);
                        } else if (qp.newlyUnlockedStamps.isNotEmpty) {
                          context.pushReplacement(AppRoutes.stamp);
                        } else if (qp.hasPendingAllStarsCelebration) {
                          qp.consumeAllStarsCelebration();
                          context.pushReplacement(AppRoutes.allStars);
                        } else if (qp.hasPendingAllBadgesCelebration) {
                          qp.consumeAllBadgesCelebration();
                          context.pushReplacement(AppRoutes.allBadges);
                        } else {
                          qp.resetQuiz();
                          context.pop();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: _bgDark,
                  disabledBackgroundColor: _gold.withAlpha(70),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 10,
                  shadowColor: _gold.withAlpha(150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Old Bird Widget ──────────────────────────────────────────────────────────
class _OldBird extends StatelessWidget {
  final String imagePath;
  final double slideProgress;  // 0→1 slide in from below
  final double fadeOut;        // 1→0 fade out
  final double shake;          // 0→1 shake intensity

  const _OldBird({
    required this.imagePath,
    required this.slideProgress,
    required this.fadeOut,
    required this.shake,
  });

  @override
  Widget build(BuildContext context) {
    final intensity = shake;
    double dx = 0, dy = 0;
    if (intensity > 0) {
      dx = sin(intensity * pi * 60) * 22 * intensity;
      dy = cos(intensity * pi * 48) * 22 * intensity;
    }
    final slideOffset = (1 - slideProgress) * 120;

    return Opacity(
      opacity: (slideProgress * fadeOut).clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(dx, dy + slideOffset),
        child: Transform.scale(
          scale: 0.85 + slideProgress * 0.15,
          child: Image.asset(imagePath, width: 210, height: 210, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// ─── New Bird Widget ──────────────────────────────────────────────────────────
class _NewBird extends StatelessWidget {
  final String imagePath;
  final double popProgress; // 0→1 elastic pop

  const _NewBird({required this.imagePath, required this.popProgress});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: popProgress,
      child: Opacity(
        opacity: popProgress.clamp(0.0, 1.0),
        child: Image.asset(imagePath, width: 230, height: 230, fit: BoxFit.contain),
      ),
    );
  }
}

// ─── Glowing Text Widget ──────────────────────────────────────────────────────
class _GlowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Color glowColor;
  final double letterSpacing;

  const _GlowText(
    this.text, {
    required this.fontSize,
    required this.color,
    required this.glowColor,
    this.letterSpacing = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: letterSpacing,
        shadows: [
          Shadow(color: glowColor.withAlpha(200), blurRadius: 18),
          Shadow(color: glowColor.withAlpha(100), blurRadius: 40),
        ],
      ),
    );
  }
}

// ─── Stage Chip ───────────────────────────────────────────────────────────────
class _StageChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool bold;

  const _StageChip({required this.label, required this.color, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(160), width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: bold ? 16 : 14,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Bird Thumbnail ───────────────────────────────────────────────────────────
class _BirdThumb extends StatelessWidget {
  final String imagePath;
  final String label;
  final Color accent;
  final bool dimmed;

  const _BirdThumb({
    required this.imagePath,
    required this.label,
    required this.accent,
    required this.dimmed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent.withAlpha(180), width: 2),
            color: accent.withAlpha(20),
          ),
          padding: const EdgeInsets.all(8),
          child: Opacity(
            opacity: dimmed ? 0.5 : 1.0,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: 12,
            fontWeight: dimmed ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─── Background ───────────────────────────────────────────────────────────────
class _Background extends StatelessWidget {
  final double introBgFade;
  final double mainProgress;
  final double pulse;

  const _Background({
    required this.introBgFade,
    required this.mainProgress,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    // During build-up: dark teal pulse. Post-flash: deep navy.
    final isBuildUp = mainProgress > 0.18 && mainProgress < 0.55;
    final glowAlpha = isBuildUp ? ((0.25 + pulse * 0.20) * 255).toInt() : 0;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            const Color(0xFF00695C).withAlpha(glowAlpha),
            Color.lerp(_bgDark, _bgMid, introBgFade)!,
          ],
          stops: const [0.25, 1.0],
        ),
      ),
    );
  }
}

// ─── Energy Rings ─────────────────────────────────────────────────────────────
class _EnergyRings extends StatelessWidget {
  final double progress;

  const _EnergyRings({required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _RingPainter(progress),
        size: Size.infinite,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (int i = 0; i < 4; i++) {
      final p = ((progress - i * 0.12) / 0.7).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final radius = 55.0 + p * 260;
      final opacity = (1 - p) * 0.65;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = _amber.withAlpha((opacity * 255).toInt())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * (1 - p * 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

// ─── Orbiting Sparkles ────────────────────────────────────────────────────────
class _OrbitSparkles extends StatelessWidget {
  final double buildProgress; // 0→1
  final double sparkleT;      // loops 0→1

  static final _rng = Random(42);
  static final _data = List.generate(20, (_) => _SparkleData(_rng));

  const _OrbitSparkles({required this.buildProgress, required this.sparkleT});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _SparklesPainter(_data, sparkleT, buildProgress),
        size: Size.infinite,
      ),
    );
  }
}

class _SparkleData {
  final double angle, radius, phase, size;
  _SparkleData(Random rng)
      : angle = rng.nextDouble() * 2 * pi,
        radius = 65 + rng.nextDouble() * 120,
        phase = rng.nextDouble(),
        size = 3 + rng.nextDouble() * 5;
}

class _SparklesPainter extends CustomPainter {
  final List<_SparkleData> data;
  final double t, progress;

  _SparklesPainter(this.data, this.t, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (final s in data) {
      final orbitAngle = s.angle + progress * 2.5;
      final drift = sin((t + s.phase) * 2 * pi) * 14;
      final pos = center + Offset(
        cos(orbitAngle) * (s.radius + drift),
        sin(orbitAngle) * (s.radius + drift),
      );
      final brightness = 0.4 + sin((t + s.phase) * 2 * pi) * 0.6;
      final opacity = progress.clamp(0.0, 1.0) * brightness.clamp(0.0, 1.0);
      _drawStar(
        canvas,
        pos,
        s.size * (0.7 + brightness * 0.3),
        _amber.withAlpha((opacity * 220).toInt()),
      );
    }
  }

  void _drawStar(Canvas canvas, Offset c, double sz, Color color) {
    final path = Path();
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final a = (i / 4) * 2 * pi;
      final inner = a + pi / 4;
      final tip = c + Offset(cos(a) * sz, sin(a) * sz);
      final inn = c + Offset(cos(inner) * sz * 0.35, sin(inner) * sz * 0.35);
      if (i == 0) {
        path.moveTo(tip.dx, tip.dy);
      } else {
        path.lineTo(tip.dx, tip.dy);
      }
      path.lineTo(inn.dx, inn.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

// ─── Fireworks ────────────────────────────────────────────────────────────────
class _FireworkBurst {
  final double x, y, delay, radius;
  final Color color;
  final int particleCount;

  _FireworkBurst({
    required this.x,
    required this.y,
    required this.delay,
    required this.color,
    required this.particleCount,
    required this.radius,
  });
}

class _Fireworks extends StatelessWidget {
  final List<_FireworkBurst> bursts;
  final double progress;

  const _Fireworks({required this.bursts, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _FireworksPainter(bursts, progress),
        size: Size.infinite,
      ),
    );
  }
}

class _FireworksPainter extends CustomPainter {
  final List<_FireworkBurst> bursts;
  final double progress;

  _FireworksPainter(this.bursts, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final burst in bursts) {
      final local = ((progress - burst.delay) / (1 - burst.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      // Each burst plays and fades over ~0.5 of its local time
      final opacity = (1 - Curves.easeIn.transform(
        ((local - 0.35) / 0.65).clamp(0.0, 1.0),
      )).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final center = Offset(size.width * burst.x, size.height * burst.y);
      final dist = Curves.easeOutQuart.transform(local) * burst.radius;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = burst.color.withAlpha((opacity * 255).toInt());

      for (int i = 0; i < burst.particleCount; i++) {
        final angle = (i / burst.particleCount) * 2 * pi;
        final pos = center + Offset(cos(angle) * dist, sin(angle) * dist);
        canvas.drawCircle(pos, 3.5 * opacity, paint);
        // Trail line
        final trailPaint = Paint()
          ..color = burst.color.withAlpha((opacity * 100).toInt())
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          center + Offset(cos(angle) * dist * 0.6, sin(angle) * dist * 0.6),
          pos,
          trailPaint,
        );
      }
      // Bright center flash
      canvas.drawCircle(
        center,
        15 * (1 - local) * opacity,
        Paint()..color = Colors.white.withAlpha((opacity * 180 * (1 - local)).toInt()),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter old) =>
      old.progress != progress;
}

// ─── Confetti ─────────────────────────────────────────────────────────────────
class _ConfettiPiece {
  final double x, speed, delay, width, height, angle, spin;
  final Color color;

  const _ConfettiPiece({
    required this.x,
    required this.speed,
    required this.delay,
    required this.width,
    required this.height,
    required this.angle,
    required this.spin,
    required this.color,
  });
}

class _ConfettiRain extends StatelessWidget {
  final List<_ConfettiPiece> pieces;
  final double loopT;             // 0→1 loop
  final double celebrationProgress; // 0→1 fade in

  const _ConfettiRain({
    required this.pieces,
    required this.loopT,
    required this.celebrationProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (celebrationProgress <= 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(pieces, loopT, celebrationProgress),
        size: Size.infinite,
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double loopT;
  final double alpha;

  _ConfettiPainter(this.pieces, this.loopT, this.alpha);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      // Each piece has its own phase offset
      final t = ((loopT - p.delay + 1) % 1.0);
      final y = size.height * (t * (1 + p.speed));
      if (y < 0 || y > size.height + 20) continue;

      final x = size.width * p.x + sin(t * 2 * pi * 1.5 + p.angle) * 30;
      final spin = p.spin * t;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(spin);

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.width, height: p.height),
        Paint()..color = p.color.withAlpha((alpha * 220).clamp(0, 255).toInt()),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.loopT != loopT || old.alpha != alpha;
}

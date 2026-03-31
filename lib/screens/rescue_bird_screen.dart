import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/bird.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/navigation_utils.dart';

class RescueBirdScreen extends StatefulWidget {
  const RescueBirdScreen({super.key});

  @override
  State<RescueBirdScreen> createState() => _RescueBirdScreenState();
}

class _RescueBirdScreenState extends State<RescueBirdScreen>
    with TickerProviderStateMixin {
  static const int _puzzlesPerSession = 3;
  static const int _maxWrong = 6;

  late ConfettiController _confettiController;
  late AnimationController _catController;
  Animation<double> _catClimb = const AlwaysStoppedAnimation(0.0);
  late AnimationController _birdEventController;
  late AnimationController _idleController;

  Bird? _currentBird;
  String _displayName = '';
  Set<String> _lettersInWord = {};
  final Set<String> _guessedLetters = {};

  int _wrongGuesses = 0;
  int _rescuedThisSession = 0;
  int _currentPuzzleIndex = 0;
  bool _isCompleted = false;
  bool _isFailed = false;

  // Variation indices — randomised each puzzle
  int _birdVariation = 0; // 0-6
  int _foeVariation = 0; // 0-5

  static const List<String> _foeNames = [
    'cat',
    'snake',
    'fox',
    'raccoon',
    'spider',
    'hawk',
  ];

  String get _foeName => _foeNames[_foeVariation];

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _catController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _birdEventController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
      _startNewPuzzle();
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _confettiController.dispose();
    _catController.dispose();
    _birdEventController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  void _startNewPuzzle() {
    _catController.reset();
    _catClimb = const AlwaysStoppedAnimation(0.0);
    _birdEventController.reset();

    final rng = math.Random();
    setState(() {
      _isCompleted = false;
      _isFailed = false;
      _guessedLetters.clear();
      _wrongGuesses = 0;
      _birdVariation = rng.nextInt(7);
      _foeVariation = rng.nextInt(6);
      _currentBird = (availableBirds.toList()..shuffle()).first;
      _displayName = _currentBird!.name.toUpperCase();
      _lettersInWord = _displayName
          .split('')
          .where((c) => c.contains(RegExp(r'[A-Z]')))
          .toSet();
    });
  }

  void _animateCatTo(double target) {
    final from = _catClimb.value;
    _catClimb = Tween<double>(
      begin: from,
      end: target,
    ).animate(CurvedAnimation(parent: _catController, curve: Curves.easeOut));
    _catController.forward(from: 0);
  }

  void _onLetterTapped(String letter) {
    if (_isCompleted || _isFailed || _guessedLetters.contains(letter)) return;

    setState(() => _guessedLetters.add(letter));

    final inWord = _lettersInWord.contains(letter);
    final audio = context.read<AudioService>();

    if (inWord) {
      audio.playCorrectSound();
      _checkCompletion();
    } else {
      audio.playWrongSound();
      setState(() => _wrongGuesses++);
      _animateCatTo(_wrongGuesses / _maxWrong);
      if (_wrongGuesses >= _maxWrong) {
        Future.delayed(const Duration(milliseconds: 680), () {
          if (mounted) {
            setState(() {
              _isFailed = true;
              _currentPuzzleIndex++;
            });
            _birdEventController.forward();
          }
        });
      }
    }
  }

  void _checkCompletion() {
    if (!_lettersInWord.every(_guessedLetters.contains)) return;

    setState(() {
      _isCompleted = true;
      _rescuedThisSession++;
      _currentPuzzleIndex++;
    });

    _confettiController.play();
    _birdEventController.forward();
    context.read<QuizProvider>().incrementRescuedBirds();
  }

  void _onNextPressed() {
    if (_currentPuzzleIndex >= _puzzlesPerSession) {
      context.read<QuizProvider>().saveRescueBirdStars(
        _rescuedThisSession,
        totalPuzzles: _puzzlesPerSession,
      );
      context.pushReplacement(AppRoutes.result);
      return;
    }
    _startNewPuzzle();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBird == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B5E20),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Text(
                    _isCompleted || _isFailed
                        ? ''
                        : 'Guess letters to reveal the bird — '
                              '${_maxWrong - _wrongGuesses} wrong guesses '
                              'before the $_foeName reaches the nest!',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                _buildScene(),
                const SizedBox(height: 4),
                _buildLivesRow(),
                const SizedBox(height: 12),
                _buildWordBlanks(),
                const Spacer(),
                if (_isCompleted || _isFailed)
                  _buildOutcome()
                else
                  _buildKeyboard(),
                const SizedBox(height: 6),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black26,
      child: Row(
        children: [
          NavigationUtils.buildBackButton(context, color: Colors.white),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Rescue the Bird',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Puzzle ${math.min(_currentPuzzleIndex + 1, _puzzlesPerSession)}'
                  ' of $_puzzlesPerSession',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_nature,
                  color: Colors.yellowAccent,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_rescuedThisSession saved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScene() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _catController,
        _birdEventController,
        _idleController,
      ]),
      builder: (context, _) {
        final sceneHeight = (MediaQuery.of(context).size.shortestSide * 0.55)
            .clamp(200.0, 420.0);
        return SizedBox(
          height: sceneHeight,
          width: double.infinity,
          child: CustomPaint(
            painter: _RescueScenePainter(
              catClimb: _catClimb.value,
              birdEvent: _birdEventController.value,
              idlePulse: _idleController.value,
              isCompleted: _isCompleted,
              isFailed: _isFailed,
              wrongGuesses: _wrongGuesses,
              maxWrong: _maxWrong,
              birdVariation: _birdVariation,
              foeVariation: _foeVariation,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLivesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, color: Colors.white.withValues(alpha: 0.5), size: 15),
        const SizedBox(width: 6),
        ...List.generate(_maxWrong, (i) {
          final used = i < _wrongGuesses;
          final dotSize = (MediaQuery.of(context).size.width * 0.055).clamp(
            22.0,
            38.0,
          );
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: used
                  ? Colors.redAccent.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: used
                ? Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: dotSize * 0.6,
                  )
                : null,
          );
        }),
        const SizedBox(width: 6),
        Icon(
          Icons.egg_alt_rounded,
          color: Colors.white.withValues(alpha: 0.5),
          size: 15,
        ),
      ],
    );
  }

  Widget _buildWordBlanks() {
    final chars = _displayName.split('');
    final letterCount = chars.where((c) => c.contains(RegExp(r'[A-Z]'))).length;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Compute tile width so all letters fill available width, capped sensibly
        final spacing = 6.0;
        final hPad = 12.0;
        final available = constraints.maxWidth - hPad * 2;
        final tileW = letterCount > 0
            ? ((available - spacing * (letterCount - 1)) / letterCount).clamp(
                30.0,
                56.0,
              )
            : 38.0;
        final tileH = tileW * 1.26;
        final fontSize = tileW * 0.55;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: 8,
            children: chars.map((ch) {
              if (!ch.contains(RegExp(r'[A-Z]'))) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 8,
                  ),
                  child: Text(
                    ch,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                );
              }
              final isRevealed = _guessedLetters.contains(ch);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: tileW,
                height: tileH,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isRevealed
                      ? Colors.greenAccent.withValues(alpha: 0.25)
                      : _isFailed
                      ? Colors.redAccent.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isRevealed
                        ? Colors.greenAccent
                        : _isFailed
                        ? Colors.redAccent.shade100
                        : Colors.white38,
                    width: 2,
                  ),
                ),
                child: Text(
                  (isRevealed || _isFailed) ? ch : '',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: isRevealed
                        ? Colors.greenAccent
                        : Colors.redAccent.shade100,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildKeyboard() {
    const rows = ['ABCDEFG', 'HIJKLMN', 'OPQRSTU', 'VWXYZ'];
    const maxKeysPerRow = 7;
    const keyGap = 6.0; // 3px each side
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyWidth =
              (constraints.maxWidth - maxKeysPerRow * keyGap) / maxKeysPerRow;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.split('').map((letter) {
                    final guessed = _guessedLetters.contains(letter);
                    final correct = guessed && _lettersInWord.contains(letter);
                    final wrong = guessed && !correct;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        width: keyWidth,
                        child: AspectRatio(
                          aspectRatio: 1.1,
                          child: GestureDetector(
                            onTap:
                                guessed ? null : () => _onLetterTapped(letter),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: correct
                                    ? Colors.greenAccent.withValues(alpha: 0.25)
                                    : wrong
                                    ? Colors.redAccent.withValues(alpha: 0.12)
                                    : Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: correct
                                      ? Colors.greenAccent
                                      : wrong
                                      ? Colors.redAccent.withValues(alpha: 0.3)
                                      : Colors.white38,
                                  width: 1.5,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: correct
                                        ? Colors.greenAccent
                                        : wrong
                                        ? Colors.white24
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildOutcome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_isCompleted)
            const Text(
              'Bird Rescued!',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          else ...[
            Text(
              'The $_foeName got it...',
              style: TextStyle(
                color: Colors.redAccent.shade100,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The bird was: ${_currentBird!.name}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCompleted
                  ? Colors.greenAccent
                  : Colors.white70,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: Icon(
              _currentPuzzleIndex >= _puzzlesPerSession
                  ? Icons.check_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              _currentPuzzleIndex >= _puzzlesPerSession
                  ? 'View Results'
                  : 'Next Bird',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scene painter
// ─────────────────────────────────────────────────────────────────────────────

class _RescueScenePainter extends CustomPainter {
  final double catClimb; // 0 = foe at base / start  →  1 = foe at nest
  final double birdEvent; // 0→1: fly (win) or captured (fail) animation
  final double idlePulse; // 0→1 looping idle
  final bool isCompleted;
  final bool isFailed;
  final int wrongGuesses;
  final int maxWrong;
  final int birdVariation; // 0-6
  final int foeVariation; // 0-5

  const _RescueScenePainter({
    required this.catClimb,
    required this.birdEvent,
    required this.idlePulse,
    required this.isCompleted,
    required this.isFailed,
    required this.wrongGuesses,
    required this.maxWrong,
    required this.birdVariation,
    required this.foeVariation,
  });

  // ── Bird colour palettes ────────────────────────────────────────────────────

  static const List<Color> _birdBody = [
    Colors.yellowAccent, // 0 canary
    Color(0xFFE53935), // 1 robin
    Color(0xFF1E88E5), // 2 blue tit
    Color(0xFF43A047), // 3 parrot
    Color(0xFF8E24AA), // 4 purple
    Colors.white, // 5 dove
    Color(0xFF212121), // 6 toucan
  ];

  static const List<Color> _birdWing = [
    Color(0xFFFFD54F), // 0
    Color(0xFFB71C1C), // 1
    Color(0xFF0D47A1), // 2
    Color(0xFF1B5E20), // 3
    Color(0xFF4A148C), // 4
    Color(0xFFE0E0E0), // 5
    Color(0xFF1A1A1A), // 6
  ];

  static const List<Color> _birdBeak = [
    Colors.orange, // 0
    Color(0xFFFF8F00), // 1
    Colors.yellow, // 2
    Color(0xFFE53935), // 3
    Colors.yellow, // 4
    Color(0xFFEC407A), // 5 pink
    Colors.orange, // 6 (overridden for toucan)
  ];

  // ── Main paint ─────────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final danger = maxWrong == 0 ? 0.0 : wrongGuesses / maxWrong;

    _drawSky(canvas, size, danger);
    _drawGround(canvas, size);

    // Tree geometry
    final treeX = w * 0.42;
    final treeBottom = h * 0.88;
    // Spider needs open sky to drop through — push tree into lower half
    final treeTop = foeVariation == 4 ? h * 0.52 : h * 0.08;

    _drawTree(canvas, treeX, treeTop, treeBottom, danger);

    // Nest on the branch
    final nestX = treeX + 20.0;
    final nestY = treeTop + 22.0;

    _drawNestBase(canvas, nestX, nestY);
    _drawNestRim(canvas, nestX, nestY);

    // Draw foe
    _drawFoe(canvas, size, treeX, treeBottom, nestX, nestY);

    // Draw bird
    if (isCompleted) {
      final bx = nestX + birdEvent * w * 0.55;
      final by = nestY - 10 - birdEvent * h * 0.38;
      _drawBird(canvas, bx, by, flying: true, flap: birdEvent, alpha: 1.0);
    } else if (isFailed) {
      final alpha = (1.0 - birdEvent * 3.0).clamp(0.0, 1.0);
      _drawBird(
        canvas,
        nestX,
        nestY - 10,
        flying: false,
        flap: 0,
        alpha: alpha,
      );
    } else {
      final bob = math.sin(idlePulse * math.pi) * 2.5;
      _drawBird(
        canvas,
        nestX,
        nestY - 10 + bob,
        flying: false,
        flap: 0,
        alpha: 1.0,
      );
    }
  }

  // ── Sky ────────────────────────────────────────────────────────────────────

  void _drawSky(Canvas canvas, Size size, double danger) {
    final Color topColor;
    final Color bottomColor;

    if (isFailed) {
      topColor = Color.lerp(
        const Color(0xFF1565C0),
        const Color(0xFF4A0000),
        birdEvent,
      )!;
      bottomColor = Color.lerp(
        const Color(0xFF1E88E5),
        const Color(0xFF8B0000),
        birdEvent,
      )!;
    } else if (foeVariation == 4) {
      // Spider — dark midnight sky with purple tint
      topColor = Color.lerp(
        const Color(0xFF0D0D2B),
        const Color(0xFF1A0030),
        danger * 0.8,
      )!;
      bottomColor = Color.lerp(
        const Color(0xFF1A1040),
        const Color(0xFF3A0050),
        danger * 0.6,
      )!;
    } else {
      topColor = Color.lerp(
        const Color(0xFF1565C0),
        const Color(0xFF5D1A1A),
        danger * 0.65,
      )!;
      bottomColor = Color.lerp(
        const Color(0xFF1E88E5),
        const Color(0xFF7B3311),
        danger * 0.5,
      )!;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final showStars = foeVariation == 4 || danger > 0.3;
    if (showStars) {
      final starAlpha = foeVariation == 4
          ? 0.85
          : ((danger - 0.3) / 0.7) * 0.75;
      final sp = Paint()..color = Colors.white.withValues(alpha: starAlpha);
      for (final p in [
        Offset(size.width * 0.10, size.height * 0.08),
        Offset(size.width * 0.25, size.height * 0.04),
        Offset(size.width * 0.55, size.height * 0.05),
        Offset(size.width * 0.70, size.height * 0.07),
        Offset(size.width * 0.85, size.height * 0.11),
        Offset(size.width * 0.92, size.height * 0.03),
      ]) {
        canvas.drawCircle(p, 1.5, sp);
      }
    }
  }

  // ── Ground ─────────────────────────────────────────────────────────────────

  void _drawGround(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, size.height * 0.86, size.width, size.height),
      Paint()..color = const Color(0xFF2E7D32),
    );
    canvas.drawRect(
      Rect.fromLTRB(0, size.height * 0.86, size.width, size.height * 0.89),
      Paint()..color = const Color(0xFF43A047).withValues(alpha: 0.7),
    );
  }

  // ── Tree ───────────────────────────────────────────────────────────────────

  void _drawTree(
    Canvas canvas,
    double x,
    double treeTop,
    double treeBottom,
    double danger,
  ) {
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 10, treeTop + 42, 20, treeBottom - treeTop - 42),
        const Radius.circular(5),
      ),
      trunkPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, treeTop + 22, 34, 9),
        const Radius.circular(4),
      ),
      trunkPaint,
    );

    final canopyMain = Color.lerp(
      const Color(0xFF2E7D32),
      const Color(0xFF3E2723),
      danger * 0.75,
    )!;
    final canopyEdge = Color.lerp(
      const Color(0xFF388E3C),
      const Color(0xFF4E342E),
      danger * 0.6,
    )!;

    canvas.drawCircle(Offset(x, treeTop + 44), 54, Paint()..color = canopyMain);
    canvas.drawCircle(
      Offset(x - 18, treeTop + 34),
      34,
      Paint()..color = canopyEdge.withValues(alpha: 0.65),
    );
    canvas.drawCircle(
      Offset(x + 22, treeTop + 32),
      30,
      Paint()..color = canopyEdge.withValues(alpha: 0.65),
    );
  }

  // ── Nest ───────────────────────────────────────────────────────────────────

  void _drawNestBase(Canvas canvas, double cx, double cy) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 7), width: 36, height: 14),
      Paint()..color = const Color(0xFF6D4C41),
    );
  }

  void _drawNestRim(Canvas canvas, double cx, double cy) {
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + 5), width: 34, height: 16),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  // ── Bird ───────────────────────────────────────────────────────────────────

  void _drawBird(
    Canvas canvas,
    double x,
    double y, {
    required bool flying,
    required double flap,
    required double alpha,
  }) {
    if (alpha <= 0) return;

    final bv = birdVariation;

    // Toucan special case
    if (bv == 6) {
      _drawToucan(canvas, x, y, flying: flying, flap: flap, alpha: alpha);
      return;
    }

    final bodyColor = _birdBody[bv].withValues(alpha: alpha);
    final wingColor = _birdWing[bv].withValues(alpha: alpha);
    final beakColor = _birdBeak[bv].withValues(alpha: alpha);

    canvas.drawCircle(Offset(x, y), 9, Paint()..color = bodyColor);

    // Eye
    canvas.drawCircle(
      Offset(x + 5, y - 3),
      2.5,
      Paint()..color = Colors.black.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      Offset(x + 5.5, y - 3.5),
      1.0,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );

    // Beak
    canvas.drawPath(
      Path()
        ..moveTo(x + 8, y - 1)
        ..lineTo(x + 15, y + 0.5)
        ..lineTo(x + 8, y + 2)
        ..close(),
      Paint()..color = beakColor,
    );

    final wp = Paint()..color = wingColor;
    if (flying) {
      final fo = (math.sin(flap * math.pi * 7) * 6).abs();
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x - 5, y - 4 - fo),
          width: 14,
          height: 7,
        ),
        wp,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x - 5, y + 4 + fo),
          width: 14,
          height: 7,
        ),
        wp,
      );
    } else {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 4, y + 3), width: 12, height: 6),
        wp,
      );
    }
  }

  void _drawToucan(
    Canvas canvas,
    double x,
    double y, {
    required bool flying,
    required double flap,
    required double alpha,
  }) {
    // Black body
    canvas.drawCircle(
      Offset(x, y),
      9,
      Paint()..color = const Color(0xFF212121).withValues(alpha: alpha),
    );
    // White chest patch
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 3, y + 1), width: 8, height: 10),
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
    // Eye
    canvas.drawCircle(
      Offset(x + 5, y - 3),
      2.5,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      Offset(x + 5.5, y - 3.5),
      1.0,
      Paint()..color = Colors.black.withValues(alpha: alpha),
    );
    // Big beak — orange outer, yellow inner
    canvas.drawPath(
      Path()
        ..moveTo(x + 7, y - 3)
        ..lineTo(x + 24, y + 2)
        ..lineTo(x + 7, y + 5)
        ..close(),
      Paint()..color = const Color(0xFFFF8F00).withValues(alpha: alpha),
    );
    canvas.drawPath(
      Path()
        ..moveTo(x + 7, y - 2)
        ..lineTo(x + 16, y + 1)
        ..lineTo(x + 7, y + 4)
        ..close(),
      Paint()..color = Colors.yellow.withValues(alpha: alpha),
    );
    // Wings
    final wp = Paint()
      ..color = const Color(0xFF1A1A1A).withValues(alpha: alpha);
    if (flying) {
      final fo = (math.sin(flap * math.pi * 7) * 6).abs();
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x - 5, y - 4 - fo),
          width: 14,
          height: 7,
        ),
        wp,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x - 5, y + 4 + fo),
          width: 14,
          height: 7,
        ),
        wp,
      );
    } else {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 4, y + 3), width: 12, height: 6),
        wp,
      );
    }
  }

  // ── Foe dispatcher ─────────────────────────────────────────────────────────

  void _drawFoe(
    Canvas canvas,
    Size size,
    double treeX,
    double treeBottom,
    double nestX,
    double nestY,
  ) {
    final h = size.height;
    final w = size.width;

    switch (foeVariation) {
      case 4: // Spider — descends from top
        final spiderX = nestX + 8.0;
        final spiderEndY = nestY - 16.0;
        final spiderY = h * 0.02 + (spiderEndY - h * 0.02) * catClimb;
        _drawSpider(canvas, spiderX, spiderY);

      case 5: // Hawk — swoops in from upper right
        final hawkX = (w + 55.0) + (nestX + 15.0 - w - 55.0) * catClimb;
        final hawkY = h * 0.05 + (nestY - 5.0 - h * 0.05) * catClimb;
        _drawHawk(canvas, hawkX, hawkY);

      default: // Climbers: cat 0, snake 1, fox 2, raccoon 3
        final climberBaseY = treeBottom - 20;
        final climberNestY = nestY + 12;
        final foeY = climberBaseY + (climberNestY - climberBaseY) * catClimb;
        switch (foeVariation) {
          case 0:
            _drawCat(canvas, treeX, foeY);
          case 1:
            _drawSnake(canvas, treeX, foeY, treeBottom);
          case 2:
            _drawFox(canvas, treeX, foeY);
          case 3:
            _drawRaccoon(canvas, treeX, foeY);
        }
    }
  }

  // ── Cat ────────────────────────────────────────────────────────────────────

  void _drawCat(Canvas canvas, double x, double y) {
    const baseColor = Color(0xFFFF8F00);
    final bp = Paint()..color = baseColor;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y + 9), width: 26, height: 20),
      bp,
    );
    canvas.drawCircle(Offset(x + 7, y - 5), 13, bp);

    void ear(double ex, double ey) {
      canvas.drawPath(
        Path()
          ..moveTo(ex - 5, ey)
          ..lineTo(ex, ey - 10)
          ..lineTo(ex + 5, ey)
          ..close(),
        bp,
      );
      canvas.drawPath(
        Path()
          ..moveTo(ex - 3, ey - 1)
          ..lineTo(ex, ey - 7)
          ..lineTo(ex + 3, ey - 1)
          ..close(),
        Paint()..color = Colors.pink.shade200,
      );
    }

    ear(x + 2, y - 15);
    ear(x + 12, y - 15);

    final eyeColor = isFailed
        ? Colors.redAccent
        : Color.lerp(Colors.greenAccent, Colors.redAccent, catClimb)!;
    canvas.drawCircle(Offset(x + 4, y - 6), 3, Paint()..color = eyeColor);
    canvas.drawCircle(Offset(x + 11, y - 6), 3, Paint()..color = eyeColor);
    canvas.drawCircle(Offset(x + 4, y - 6), 1.5, Paint()..color = Colors.black);
    canvas.drawCircle(
      Offset(x + 11, y - 6),
      1.5,
      Paint()..color = Colors.black,
    );
    canvas.drawCircle(
      Offset(x + 7.5, y - 1.5),
      2,
      Paint()..color = Colors.pink.shade300,
    );

    final wp = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (final d in [-1, 0, 1]) {
      canvas.drawLine(
        Offset(x + 1, y - 1 + d * 3.0),
        Offset(x - 14, y - 2 + d * 1.5),
        wp,
      );
      canvas.drawLine(
        Offset(x + 14, y - 1 + d * 3.0),
        Offset(x + 26, y - 2 + d * 1.5),
        wp,
      );
    }

    canvas.drawPath(
      Path()
        ..moveTo(x - 10, y + 14)
        ..quadraticBezierTo(x - 28, y + 6, x - 22, y - 8),
      Paint()
        ..color = baseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  // ── Snake ──────────────────────────────────────────────────────────────────

  void _drawSnake(Canvas canvas, double x, double headY, double treeBottom) {
    // Winding body trailing below the head
    final path = Path();
    path.moveTo(x, headY);
    const segments = 7;
    const segLen = 16.0;
    const amplitude = 7.0;
    double cy = headY;
    for (int i = 0; i < segments; i++) {
      final offset = (i % 2 == 0) ? amplitude : -amplitude;
      cy += segLen;
      if (cy > treeBottom + 20) break;
      path.lineTo(x + offset, cy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF388E3C)
        ..strokeWidth = 9
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Head
    canvas.drawCircle(
      Offset(x, headY),
      9,
      Paint()..color = const Color(0xFF2E7D32),
    );

    // Scales pattern on head
    canvas.drawCircle(
      Offset(x, headY),
      9,
      Paint()
        ..color = const Color(0xFF1B5E20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Eyes
    final eyeColor = isFailed ? Colors.redAccent : Colors.yellowAccent;
    canvas.drawCircle(Offset(x - 3, headY - 3), 2.5, Paint()..color = eyeColor);
    canvas.drawCircle(Offset(x + 3, headY - 3), 2.5, Paint()..color = eyeColor);
    canvas.drawCircle(
      Offset(x - 3, headY - 3),
      1.2,
      Paint()..color = Colors.black,
    );
    canvas.drawCircle(
      Offset(x + 3, headY - 3),
      1.2,
      Paint()..color = Colors.black,
    );

    // Forked tongue (flicks with idle)
    final tongueLen = 8 + math.sin(idlePulse * math.pi) * 4;
    final tp = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x, headY - 9), Offset(x, headY - 9 - tongueLen), tp);
    canvas.drawLine(
      Offset(x, headY - 9 - tongueLen),
      Offset(x - 4, headY - 9 - tongueLen - 5),
      tp,
    );
    canvas.drawLine(
      Offset(x, headY - 9 - tongueLen),
      Offset(x + 4, headY - 9 - tongueLen - 5),
      tp,
    );
  }

  // ── Fox ────────────────────────────────────────────────────────────────────

  void _drawFox(Canvas canvas, double x, double y) {
    const baseColor = Color(0xFFBF360C);
    final bp = Paint()..color = baseColor;

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y + 9), width: 24, height: 18),
      bp,
    );

    // Head
    canvas.drawCircle(Offset(x + 7, y - 4), 12, bp);

    // Pointed ears (larger than cat)
    void ear(double ex, double ey) {
      canvas.drawPath(
        Path()
          ..moveTo(ex - 5, ey)
          ..lineTo(ex, ey - 13)
          ..lineTo(ex + 5, ey)
          ..close(),
        bp,
      );
      canvas.drawPath(
        Path()
          ..moveTo(ex - 3, ey - 1)
          ..lineTo(ex, ey - 9)
          ..lineTo(ex + 3, ey - 1)
          ..close(),
        Paint()..color = Colors.pink.shade100,
      );
    }

    ear(x + 2, y - 14);
    ear(x + 12, y - 14);

    // Elongated snout
    canvas.drawPath(
      Path()
        ..moveTo(x + 10, y - 2)
        ..lineTo(x + 22, y + 2)
        ..lineTo(x + 10, y + 5)
        ..close(),
      bp,
    );

    // White muzzle patch
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 13, y + 1), width: 9, height: 7),
      Paint()..color = Colors.white,
    );

    // Amber eyes
    final eyeColor = isFailed
        ? Colors.redAccent
        : Color.lerp(const Color(0xFFFFAB40), Colors.redAccent, catClimb)!;
    canvas.drawCircle(Offset(x + 4, y - 5), 2.5, Paint()..color = eyeColor);
    canvas.drawCircle(Offset(x + 10, y - 5), 2.5, Paint()..color = eyeColor);
    canvas.drawCircle(Offset(x + 4, y - 5), 1.2, Paint()..color = Colors.black);
    canvas.drawCircle(
      Offset(x + 10, y - 5),
      1.2,
      Paint()..color = Colors.black,
    );

    // Black nose at snout tip
    canvas.drawCircle(Offset(x + 21, y + 1), 2, Paint()..color = Colors.black);

    // Bushy tail
    canvas.drawPath(
      Path()
        ..moveTo(x - 10, y + 13)
        ..quadraticBezierTo(x - 34, y + 4, x - 28, y - 12),
      Paint()
        ..color = baseColor
        ..strokeWidth = 9
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    // White tail tip
    canvas.drawCircle(Offset(x - 28, y - 12), 6, Paint()..color = Colors.white);
  }

  // ── Raccoon ────────────────────────────────────────────────────────────────

  void _drawRaccoon(Canvas canvas, double x, double y) {
    const grey = Color(0xFF9E9E9E);
    const dark = Color(0xFF424242);
    final gp = Paint()..color = grey;

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y + 9), width: 26, height: 20),
      gp,
    );

    // Head
    canvas.drawCircle(Offset(x + 7, y - 5), 13, gp);

    // Round ears
    canvas.drawCircle(Offset(x + 2, y - 17), 6, gp);
    canvas.drawCircle(Offset(x + 12, y - 17), 6, gp);
    canvas.drawCircle(Offset(x + 2, y - 17), 3.5, Paint()..color = dark);
    canvas.drawCircle(Offset(x + 12, y - 17), 3.5, Paint()..color = dark);

    // Black eye mask
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 3, y - 6), width: 10, height: 7),
      Paint()..color = dark,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 11, y - 6), width: 10, height: 7),
      Paint()..color = dark,
    );

    // Eyes
    canvas.drawCircle(Offset(x + 3, y - 6), 2.5, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(x + 11, y - 6),
      2.5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(Offset(x + 3, y - 6), 1.5, Paint()..color = Colors.black);
    canvas.drawCircle(
      Offset(x + 11, y - 6),
      1.5,
      Paint()..color = Colors.black,
    );

    // White muzzle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 7, y - 1), width: 10, height: 7),
      Paint()..color = Colors.white70,
    );
    canvas.drawCircle(Offset(x + 7, y - 2), 1.5, Paint()..color = dark);

    // Ringed tail — alternating circles along a bezier
    final tailPoints = _bezierPoints(
      Offset(x - 10, y + 14),
      Offset(x - 30, y + 5),
      Offset(x - 24, y - 10),
      10,
    );
    for (int i = 0; i < tailPoints.length; i++) {
      canvas.drawCircle(
        tailPoints[i],
        4.5,
        Paint()..color = i % 2 == 0 ? grey : dark,
      );
    }
  }

  // ── Spider ─────────────────────────────────────────────────────────────────

  void _drawSpider(Canvas canvas, double x, double y) {
    // Silk thread from top
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, y),
      Paint()
        ..color = Colors.white38
        ..strokeWidth = 1.2,
    );

    const spiderColor = Color(0xFF212121);
    final sp = Paint()..color = spiderColor;

    // Abdomen
    canvas.drawCircle(Offset(x, y + 7), 8, sp);
    // Cephalothorax (head)
    canvas.drawCircle(Offset(x, y - 4), 6, sp);

    // 8 legs (4 per side, 2 joints each)
    final lp = Paint()
      ..color = spiderColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final legBaseY = y - 2 + i * 3.5;
      // Left
      canvas.drawLine(
        Offset(x - 5, legBaseY),
        Offset(x - 16, legBaseY - 6),
        lp,
      );
      canvas.drawLine(
        Offset(x - 16, legBaseY - 6),
        Offset(x - 20, legBaseY + 3),
        lp,
      );
      // Right
      canvas.drawLine(
        Offset(x + 5, legBaseY),
        Offset(x + 16, legBaseY - 6),
        lp,
      );
      canvas.drawLine(
        Offset(x + 16, legBaseY - 6),
        Offset(x + 20, legBaseY + 3),
        lp,
      );
    }

    // Red eyes (multiple, spider style)
    final eyeColor = isFailed ? Colors.red.shade900 : Colors.redAccent;
    for (int i = -1; i <= 1; i++) {
      canvas.drawCircle(
        Offset(x + i * 3.0, y - 6),
        1.5,
        Paint()..color = eyeColor,
      );
    }

    // Hourglass marking on abdomen
    canvas.drawPath(
      Path()
        ..moveTo(x - 2, y + 3)
        ..lineTo(x + 2, y + 3)
        ..lineTo(x, y + 6)
        ..lineTo(x + 2, y + 9)
        ..lineTo(x - 2, y + 9)
        ..lineTo(x, y + 6)
        ..close(),
      Paint()..color = Colors.redAccent.withValues(alpha: 0.8),
    );
  }

  // ── Hawk ───────────────────────────────────────────────────────────────────

  void _drawHawk(Canvas canvas, double x, double y) {
    const brown = Color(0xFF6D4C41);
    const darkBrown = Color(0xFF4E342E);
    const tan = Color(0xFFD7CCC8);

    // Left wing (trailing)
    canvas.drawPath(
      Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x - 22, y - 18, x - 44, y - 6)
        ..quadraticBezierTo(x - 22, y - 4, x, y + 4),
      Paint()..color = darkBrown,
    );

    // Right wing (leading, slightly angled for swoop)
    canvas.drawPath(
      Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x + 20, y - 14, x + 38, y - 4)
        ..quadraticBezierTo(x + 20, y - 2, x, y + 4),
      Paint()..color = darkBrown,
    );

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 26, height: 13),
      Paint()..color = brown,
    );

    // Tan chest
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x - 3, y + 1), width: 12, height: 8),
      Paint()..color = tan,
    );

    // Head
    canvas.drawCircle(Offset(x - 10, y - 2), 8, Paint()..color = brown);

    // Fierce eye
    final eyeColor = isFailed ? Colors.redAccent : Colors.yellowAccent;
    canvas.drawCircle(Offset(x - 13, y - 4), 2.5, Paint()..color = eyeColor);
    canvas.drawCircle(
      Offset(x - 13, y - 4),
      1.5,
      Paint()..color = Colors.black,
    );
    // Brow ridge (predator look)
    canvas.drawLine(
      Offset(x - 16, y - 7),
      Offset(x - 10, y - 6),
      Paint()
        ..color = darkBrown
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Hooked beak (pointing left)
    canvas.drawPath(
      Path()
        ..moveTo(x - 17, y - 2)
        ..lineTo(x - 24, y - 1)
        ..lineTo(x - 20, y + 4)
        ..close(),
      Paint()..color = Colors.amber,
    );

    // Tail feathers
    canvas.drawPath(
      Path()
        ..moveTo(x + 12, y - 1)
        ..lineTo(x + 22, y - 5)
        ..lineTo(x + 23, y + 1)
        ..lineTo(x + 22, y + 5)
        ..lineTo(x + 12, y + 2),
      Paint()..color = darkBrown,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<Offset> _bezierPoints(Offset p0, Offset p1, Offset p2, int count) {
    return List.generate(count, (i) {
      final t = i / (count - 1);
      final mt = 1 - t;
      return Offset(
        mt * mt * p0.dx + 2 * mt * t * p1.dx + t * t * p2.dx,
        mt * mt * p0.dy + 2 * mt * t * p1.dy + t * t * p2.dy,
      );
    });
  }

  @override
  bool shouldRepaint(_RescueScenePainter old) =>
      old.catClimb != catClimb ||
      old.birdEvent != birdEvent ||
      old.idlePulse != idlePulse ||
      old.isCompleted != isCompleted ||
      old.isFailed != isFailed ||
      old.wrongGuesses != wrongGuesses ||
      old.birdVariation != birdVariation ||
      old.foeVariation != foeVariation;
}

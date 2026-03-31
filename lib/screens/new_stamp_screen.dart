import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/stamp.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import 'achievements_book_screen.dart';

class NewStampScreen extends StatefulWidget {
  const NewStampScreen({super.key});

  @override
  State<NewStampScreen> createState() => _NewStampScreenState();
}

class _NewStampScreenState extends State<NewStampScreen>
    with TickerProviderStateMixin {
  List<Stamp> _stamps = [];
  bool _stampsInitialized = false;
  int _currentIndex = 0;

  late AnimationController _stampAnimController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  late AnimationController _shakeAnimController;
  late Animation<double> _shakeAnimation;
  bool _hasShook = false;
  bool _animationComplete = false;
  bool _isAnimating = false;

  late List<List<AchievementItem>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = AchievementsBookScreen.buildPages();

    _stampAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 6.0, end: 1.0).animate(
      CurvedAnimation(parent: _stampAnimController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _stampAnimController, curve: Curves.easeOut),
    );

    _shakeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeAnimController, curve: Curves.easeOut),
    );

    _stampAnimController.addListener(() {
      if (_scaleAnimation.value <= 1.05 && !_hasShook) {
        _hasShook = true;
        _shakeAnimController.forward(from: 0);
        context.read<AudioService>().playStampThud();
      }
    });

    _stampAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationComplete = true;
        });
        context.read<AudioService>().playLevelUpSound();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = context.read<AudioService>();
      audioService.playMenuMusic();
      _playEntryAnimation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stampsInitialized) {
      _stamps = List.from(
        Provider.of<QuizProvider>(context, listen: false).newlyUnlockedStamps,
      );
      _stampsInitialized = true;
    }
  }

  void _playEntryAnimation() async {
    setState(() {
      _hasShook = false;
      _animationComplete = false;
      _isAnimating = false;
    });

    // Slight pause to build anticipation before the slam
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    setState(() {
      _isAnimating = true;
    });

    _stampAnimController.forward(from: 0);
  }

  @override
  void dispose() {
    _stampAnimController.dispose();
    _shakeAnimController.dispose();
    super.dispose();
  }

  void _nextStamp() {
    if (_currentIndex < _stamps.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _playEntryAnimation();
    } else {
      _finish();
    }
  }

  void _finish() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.consumeNewlyUnlockedStamps();
    if (provider.hasPendingAllStarsCelebration) {
      provider.consumeAllStarsCelebration();
      context.go(AppRoutes.allStars);
    } else if (provider.hasPendingAllBadgesCelebration) {
      provider.consumeAllBadgesCelebration();
      context.go(AppRoutes.allBadges);
    } else {
      provider.resetQuiz();
      context.go(AppRoutes.main);
    }
  }

  int _getSpreadIndexForStamp(String stampId) {
    for (int p = 0; p < _pages.length; p++) {
      final page = _pages[p];
      for (int i = 0; i < page.length; i++) {
        final item = page[i];
        if (item is StampItem && item.stamp.id == stampId) {
          return p ~/ 2;
        }
      }
    }
    return 0; // fallback
  }

  Widget _buildAnimatedStamp(
    BuildContext context,
    Stamp renderStamp,
    bool isUnlocked,
  ) {
    final isTheNewStamp = renderStamp.id == _stamps[_currentIndex].id;

    if (!isTheNewStamp) {
      // Just normal rendering for other stamps on the spread
      return AchievementsBookScreen.buildStamp(context, renderStamp);
    }

    // The animated stamp
    return GestureDetector(
      onTap: () {
        AchievementsBookScreen.showStampDialog(context, renderStamp, true);
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Image animated!
            Expanded(
              flex: 4,
              child: AnimatedOpacity(
                opacity: _isAnimating ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 50),
                child: RotationTransition(
                  turns: _rotateAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.brown[800]!,
                          width: 3, // slightly thicker for new
                        ),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: AchievementsBookScreen.buildStampIconChild(
                          renderStamp,
                          true,
                          context.read<QuizProvider>().selectedBirdId,
                        ),
                      ),
                    ), // Container
                  ), // ScaleTransition
                ), // RotationTransition
              ), // AnimatedOpacity
            ), // Expanded
            const SizedBox(height: 6),
            // Title
            Expanded(
              flex: 2,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _animationComplete ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    renderStamp.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.1,
                      color: Colors.brown[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_stamps.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentStamp = _stamps[_currentIndex];
    final spreadIndex = _getSpreadIndexForStamp(currentStamp.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Stamp Unlocked!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        automaticallyImplyLeading: false, // Don't allow regular back
      ),
      backgroundColor: Colors.brown[900],
      body: Stack(
        children: [
          // Background Wood
          Positioned.fill(
            child: Image.asset(
              'assets/images/rustic_wood_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _shakeAnimController,
                    builder: (context, child) {
                      final t = _shakeAnimation.value;
                      final shakeOffset =
                          math.sin(t * math.pi * 5) * 8 * (1 - t);
                      return Transform.translate(
                        offset: Offset(shakeOffset, 0),
                        child: child,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      // We only show ONE spread. We disable scrolling completely.
                      child: AchievementsBookScreen.buildBookSpread(
                        context,
                        spreadIndex,
                        _pages,
                        stampBuilder: _buildAnimatedStamp,
                      ),
                    ),
                  ),
                ),

                // Bottom Area for Continue Button
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedOpacity(
                    opacity: _animationComplete ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !_animationComplete,
                      child: _currentIndex < _stamps.length - 1
                          ? ElevatedButton(
                              onPressed: _nextStamp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.brown[900],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'NEXT STAMP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _finish,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.brown[900],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

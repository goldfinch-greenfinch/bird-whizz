import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import '../router/app_router.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/radial_particle_burst.dart';
import '../services/audio_service.dart';

class CharacterEvolveScreen extends StatefulWidget {
  const CharacterEvolveScreen({super.key});

  @override
  State<CharacterEvolveScreen> createState() => _CharacterEvolveScreenState();
}

class _CharacterEvolveScreenState extends State<CharacterEvolveScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowScaleAnimation;
  late Animation<double> _glowOpacityAnimation;
  late Animation<double> _burstAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _popAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Phase 1: Rapid shake (0.0 to 0.55)
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    // Phase 1: Glowing light scales up (0.0 to 0.55)
    _glowScaleAnimation = Tween<double>(begin: 0.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    // Phase 2: Burst (0.55 to 1.0)
    _burstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    // Glow fades out fast (0.55 to 0.7)
    _glowOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.7, curve: Curves.easeIn),
      ),
    );

    // Pop the new bird in slightly (0.55 to 0.75)
    _popAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.75, curve: Curves.elasticOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = context.read<AudioService>();
      audioService.playMenuMusic();

      // We can play an initial sound here if we had one for ticking/energy buildup
      // But we will definitely play the main evolution sound right at the burst moment (0.55 * 2500 = 1375ms)
      Future.delayed(const Duration(milliseconds: 1375), () {
        if (mounted) {
          audioService.playLevelUpSound();
        }
      });

      // Start the evolution sequence
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900], // Darker background to emphasize glow
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: NavigationUtils.buildBackButton(context, color: Colors.white),
      ),
      body: Stack(
        children: [
          // Radial particle burst for molting effect
          RadialParticleBurst(animation: _burstAnimation),

          SafeArea(
            child: Consumer<QuizProvider>(
              builder: (context, provider, _) {
                Bird? bird;
                if (provider.selectedBirdId != null) {
                  try {
                    bird = availableBirds.firstWhere(
                      (b) => b.id == provider.selectedBirdId,
                    );
                  } catch (e) {
                    // Ignore
                  }
                }

                if (bird == null) {
                  return const Center(
                    child: Text(
                      'Bird not found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'EVOLUTION!',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your companion has grown stronger!',
                        style: TextStyle(fontSize: 18, color: Colors.teal[100]),
                      ),
                      const SizedBox(height: 60),

                      // Animation Container
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final bool isBurstPhase = _controller.value >= 0.55;

                            // Calculate intense shaking
                            double shakeOffsetDx = 0.0;
                            double shakeOffsetDy = 0.0;
                            if (!isBurstPhase && _shakeAnimation.value > 0) {
                              final intensity = _shakeAnimation.value;
                              // High frequency sine waves for jitter
                              shakeOffsetDx =
                                  sin(_shakeAnimation.value * pi * 50) *
                                  15 *
                                  intensity;
                              shakeOffsetDy =
                                  cos(_shakeAnimation.value * pi * 40) *
                                  15 *
                                  intensity;
                            }

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glowing background ball
                                if (_glowScaleAnimation.value > 0 &&
                                    _glowOpacityAnimation.value > 0)
                                  Opacity(
                                    opacity: isBurstPhase
                                        ? _glowOpacityAnimation.value
                                        : 1.0,
                                    child: Transform.scale(
                                      scale:
                                          _glowScaleAnimation.value +
                                          (isBurstPhase
                                              ? (1.0 -
                                                        _glowOpacityAnimation
                                                            .value) *
                                                    1.5
                                              : 0),
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withAlpha(255),
                                              Colors.yellow[100]!.withAlpha(
                                                200,
                                              ),
                                              Colors.white.withAlpha(0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                // Bird Sprite
                                isBurstPhase
                                    ? Transform.scale(
                                        scale: _popAnimation.value,
                                        child: Image.asset(
                                          bird!.getEvolvedImagePath(
                                            provider.newEvolutionStage!,
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Transform.translate(
                                        offset: Offset(
                                          shakeOffsetDx,
                                          shakeOffsetDy,
                                        ),
                                        child: Image.asset(
                                          bird!.getEvolvedImagePath(
                                            provider.oldEvolutionStage!,
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Continue Button
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final bool isDone = _controller.value == 1.0;
                          return AnimatedOpacity(
                            opacity: isDone ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: ElevatedButton(
                              onPressed: isDone
                                  ? () {
                                      if (provider
                                          .newlyUnlockedStamps
                                          .isNotEmpty) {
                                        context.pushReplacement(
                                          AppRoutes.stamp,
                                        );
                                      } else {
                                        provider.resetQuiz();
                                        context.go(AppRoutes.main);
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.teal[900],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

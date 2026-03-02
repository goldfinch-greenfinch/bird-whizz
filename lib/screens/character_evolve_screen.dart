import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/particle_overlay.dart';
import '../services/audio_service.dart';

class CharacterEvolveScreen extends StatefulWidget {
  final int oldStage;
  final int newStage;

  const CharacterEvolveScreen({
    super.key,
    required this.oldStage,
    required this.newStage,
  });

  @override
  State<CharacterEvolveScreen> createState() => _CharacterEvolveScreenState();
}

class _CharacterEvolveScreenState extends State<CharacterEvolveScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showNewStage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = context.read<AudioService>();
      audioService.playMenuMusic();
      audioService.playLevelUpSound(); // Play evolution sound (reused)

      // Start the evolution animation sequence
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.forward().then((_) {
            setState(() {
              _showNewStage = true;
            });
            _controller.reverse();
            // Optional: another sound effect here
          });
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
      backgroundColor: Colors.teal[800],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: NavigationUtils.buildBackButton(context, color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background burst effect
          const ParticleOverlay(
            numberOfParticles: 80,
            colors: [Colors.white, Colors.amber, Colors.orange, Colors.cyan],
          ),

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
                        height: 200,
                        width: 200,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (!_showNewStage)
                                    Opacity(
                                      opacity: _opacityAnimation.value,
                                      child: Image.asset(
                                        bird!.getEvolvedImagePath(
                                          widget.oldStage,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  if (_showNewStage)
                                    Image.asset(
                                      bird!.getEvolvedImagePath(
                                        widget.newStage,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 60),

                      AnimatedOpacity(
                        opacity: _showNewStage ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: ElevatedButton(
                          onPressed: _showNewStage
                              ? () {
                                  provider.resetQuiz();
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal[800],
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

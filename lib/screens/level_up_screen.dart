import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/particle_overlay.dart';
import '../models/bird.dart';

import '../services/audio_service.dart';

class LevelUpScreen extends StatefulWidget {
  const LevelUpScreen({super.key});

  @override
  State<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends State<LevelUpScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = context.read<AudioService>();
      audioService.playMenuMusic();
      audioService.playLevelUpSound();
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path _drawFeather(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width,
      size.height / 2,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(0, size.height / 2, size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    Bird? selectedBird;
    if (provider.selectedBirdId != null) {
      try {
        selectedBird = availableBirds.firstWhere(
          (b) => b.id == provider.selectedBirdId,
        );
      } catch (e) {
        // Fallback
      }
    }

    return Scaffold(
      backgroundColor: Colors.teal[50], // Match old finish screen background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: NavigationUtils.buildBackButton(
          context,
          color: Colors.teal[900]!,
        ),
        actions: [
          NavigationUtils.buildProfileMenu(context, color: Colors.teal[900]!),
        ],
      ),
      body: Stack(
        children: [
          const ParticleOverlay(
            numberOfParticles: 60,
            colors: [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedBird != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedBird.color, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: selectedBird.color.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          selectedBird.getEvolvedImagePath(
                            provider.userEvolutionStage,
                          ),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.workspace_premium,
                      size: 100,
                      color: Colors.amber,
                    ),
                  const SizedBox(height: 30),
                  Text(
                    'CONGRATULATIONS!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.teal[900],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'You have leveled up from',
                    style: TextStyle(color: Colors.teal[700], fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      provider.oldLevelTitle ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.teal[800],
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Icon(Icons.arrow_downward, color: Colors.teal[400], size: 32),
                  const SizedBox(height: 20),
                  Text(
                    'To',
                    style: TextStyle(color: Colors.teal[700], fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      provider.newLevelTitle ?? 'Bird Wizard',
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black12,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<QuizProvider>(
                        context,
                        listen: false,
                      );
                      provider.consumeLevelUp();
                      if (provider.hasEvolved) {
                        context.pushReplacement(AppRoutes.evolve);
                      } else if (provider.newlyUnlockedStamps.isNotEmpty) {
                        context.pushReplacement(AppRoutes.stamp);
                      } else {
                        provider.resetQuiz();
                        context.go(AppRoutes.main);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
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
                ],
              ),
            ),
          ),
          // Regular Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
          // Feather Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              createParticlePath: _drawFeather,
              colors: const [
                Colors.white,
                Colors.grey,
                Colors.brown,
                Color(0xFF8D6E63), // Brown
                Color(0xFFFFCC80), // Light Orange/Cream
              ],
            ),
          ),
        ],
      ),
    );
  }
}

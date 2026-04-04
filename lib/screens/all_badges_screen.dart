import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/stamp.dart';
import '../services/audio_service.dart';
import '../widgets/particle_overlay.dart';

class AllBadgesScreen extends StatefulWidget {
  const AllBadgesScreen({super.key});

  @override
  State<AllBadgesScreen> createState() => _AllBadgesScreenState();
}

class _AllBadgesScreenState extends State<AllBadgesScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 6),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playLevelUpSound();
      _confettiController.play();
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _continue() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.resetQuiz();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final total = gameStamps.length;
    final collected = provider.unlockedStamps.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      body: Stack(
        children: [
          const ParticleOverlay(
            numberOfParticles: 80,
            colors: [
              Colors.brown,
              Color(0xFFFFCC80),
              Colors.orange,
              Colors.white,
              Color(0xFFD7CCC8),
            ],
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.brown.withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(0xFFFFCC80),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 80,
                          color: Color(0xFFFFCC80),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'ALL BADGES COLLECTED!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFCC80),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.brown.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFCC80).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        '$collected / $total badges',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'The Achievement Book is complete!\nYou\'ve collected every single badge.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFFCC80),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 52),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCC80),
                          foregroundColor: Colors.brown[900],
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: Colors.orange.withValues(alpha: 0.5),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFFFCC80),
                Colors.orange,
                Colors.brown,
                Colors.white,
                Color(0xFFD7CCC8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

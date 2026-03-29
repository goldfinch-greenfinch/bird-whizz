import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/particle_overlay.dart';

class EndlessResultScreen extends StatefulWidget {
  const EndlessResultScreen({super.key});

  @override
  State<EndlessResultScreen> createState() => _EndlessResultScreenState();
}

class _EndlessResultScreenState extends State<EndlessResultScreen> {
  int _stars = 0;
  bool _initialized = false;
  String _message = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      _calculateResult(provider);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final audioService = context.read<AudioService>();
        audioService.playMenuMusic();
        audioService.playQuizCompleteSound();
      });

      _initialized = true;
    }
  }

  void _calculateResult(QuizProvider provider) {
    final int streak = provider.lastEndlessStreak;

    if (streak >= 50) {
      _stars = 3;
      _message = 'Legendary run! You soared past 50 in a row!';
    } else if (streak >= 20) {
      _stars = 2;
      _message = 'Amazing focus – a streak of 20+ questions!';
    } else if (streak >= 10) {
      _stars = 1;
      _message = 'Great job keeping your streak above 10!';
    } else if (streak > 0) {
      _stars = 0;
      _message = 'Nice warm-up run – keep going to reach 10, 20 and 50+!';
    } else {
      _stars = 0;
      _message = 'Give Endless Mode another try and build that streak!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final int streak = provider.lastEndlessStreak;
    final int best = provider.endlessHighScore;

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Stack(
        children: [
          if (_stars >= 3)
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
          if (_stars == 2)
            const ParticleOverlay(
              numberOfParticles: 30,
              colors: [Colors.blue, Colors.teal, Colors.lightBlueAccent],
            ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  leading: NavigationUtils.buildBackButton(
                    context,
                    color: Colors.black87,
                  ),
                  actions: [
                    NavigationUtils.buildProfileMenu(
                      context,
                      color: Colors.black87,
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Endless Mode',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          _buildHeaderObject(),
                          const SizedBox(height: 20),
                          Text(
                            'Run Complete!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildScoreCard(streak, best),
                          const SizedBox(height: 30),
                          _buildMessageCard(),
                          const SizedBox(height: 40),
                          _buildActionButtons(context, provider),
                          const SizedBox(height: 20),
                        ],
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

  Widget _buildHeaderObject() {
    IconData icon;
    Color color;
    double size = 80;

    if (_stars == 3) {
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (_stars == 2) {
      icon = Icons.local_fire_department;
      color = Colors.orangeAccent;
    } else if (_stars == 1) {
      icon = Icons.trending_up;
      color = Colors.teal;
    } else {
      icon = Icons.refresh;
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  Widget _buildScoreCard(int streak, int best) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Streak',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Best Streak: $best',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < _stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.teal[100]?.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
      ),
      child: Text(
        _message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: Colors.teal[900],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizProvider provider) {
    final bool hasNextScreen =
        provider.hasLeveledUp ||
        provider.hasEvolved ||
        provider.newlyUnlockedStamps.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: () {
          if (provider.hasLeveledUp) {
            context.pushReplacement(AppRoutes.levelUp);
          } else if (provider.hasEvolved) {
            context.pushReplacement(AppRoutes.evolve);
          } else if (provider.newlyUnlockedStamps.isNotEmpty) {
            context.pushReplacement(AppRoutes.stamp);
          } else {
            provider.resetQuiz();
            context.go(AppRoutes.main);
          }
        },
        child: Text(
          hasNextScreen ? 'Next…' : 'Return to Home',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

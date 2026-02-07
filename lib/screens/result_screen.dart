import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';

import '../widgets/navigation_utils.dart';
import '../data/result_messages.dart';
import '../widgets/particle_overlay.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _message = "";
  int _stars = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      _calculateResult(provider);

      // Play sound effects and ensure menu music
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final audioService = context.read<AudioService>();
        audioService.playMenuMusic();
        audioService.playQuizCompleteSound();
      });

      _initialized = true;
    }
  }

  void _calculateResult(QuizProvider provider) {
    int total = provider.totalQuestions;
    int score = provider.score;

    if (score == total && total > 0) {
      _stars = 3;
      _message =
          ResultMessages.perfectMessages[Random().nextInt(
            ResultMessages.perfectMessages.length,
          )];
    } else if (score >= 8) {
      _stars = 2;
      _message = ResultMessages
          .greatMessages[Random().nextInt(ResultMessages.greatMessages.length)];
    } else if (score >= 6) {
      _stars = 1;
      _message = ResultMessages
          .goodMessages[Random().nextInt(ResultMessages.goodMessages.length)];
    } else {
      _stars = 0;
      _message =
          ResultMessages.tryAgainMessages[Random().nextInt(
            ResultMessages.tryAgainMessages.length,
          )];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.teal[50], // Light background
      body: Stack(
        children: [
          // Background Effects
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

          // Main Content
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
                            'Quiz Finished!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildScoreCard(provider),
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
    // Dynamic icon/image based on score
    IconData icon;
    Color color;
    double size = 80;

    if (_stars == 3) {
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (_stars == 2) {
      icon = Icons.thumb_up;
      color = Colors.teal;
    } else if (_stars == 1) {
      icon = Icons.lightbulb;
      color = Colors.orangeAccent;
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
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  Widget _buildScoreCard(QuizProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${provider.score} / ${provider.totalQuestions}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < _stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 48,
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
        color: Colors.teal[100]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
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
          provider.resetQuiz();
          Navigator.pop(context);
        },
        child: const Text(
          'Return to Home',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

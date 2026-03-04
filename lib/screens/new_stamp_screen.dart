import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/stamp.dart';
import '../widgets/particle_overlay.dart';
import '../services/audio_service.dart';
import 'achievements_book_screen.dart';

class NewStampScreen extends StatefulWidget {
  final List<Stamp> stamps;
  final Widget? nextScreen;

  const NewStampScreen({super.key, required this.stamps, this.nextScreen});

  @override
  State<NewStampScreen> createState() => _NewStampScreenState();
}

class _NewStampScreenState extends State<NewStampScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = context.read<AudioService>();
      audioService.playMenuMusic();
      audioService.playLevelUpSound(); // Reuse success sound
    });
  }

  void _nextStamp() {
    if (_currentIndex < widget.stamps.length - 1) {
      setState(() {
        _currentIndex++;
      });
      // Play sound for each stamp
      final audioService = context.read<AudioService>();
      audioService.playLevelUpSound();
    } else {
      // Done with all stamps
      final provider = Provider.of<QuizProvider>(context, listen: false);
      provider.consumeNewlyUnlockedStamps();

      if (widget.nextScreen != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => widget.nextScreen!),
        );
      } else {
        provider.resetQuiz();
        Navigator.pop(context); // Return to home
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stamps.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final stamp = widget.stamps[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.teal[800],
      body: Stack(
        children: [
          // Background burst effect
          const ParticleOverlay(
            numberOfParticles: 60,
            colors: [Colors.yellow, Colors.amber, Colors.orange, Colors.white],
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'NEW STAMP UNLOCKED!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_currentIndex + 1} of ${widget.stamps.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Stamp Display
                    Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                        border: Border.all(color: Colors.amber, width: 6),
                      ),
                      child: ClipOval(
                        child: Image.asset(stamp.iconPath, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Text(
                      stamp.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      stamp.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 60),

                    if (_currentIndex < widget.stamps.length - 1)
                      ElevatedButton(
                        onPressed: _nextStamp,
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
                    else ...[
                      ElevatedButton(
                        onPressed: () {
                          // Clean up stamps
                          final provider = Provider.of<QuizProvider>(
                            context,
                            listen: false,
                          );
                          provider.consumeNewlyUnlockedStamps();
                          provider.resetQuiz();

                          // Navigate to Achievements Book
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AchievementsBookScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.teal[900],
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
                          'SEE IN BOOK',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _nextStamp,
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import 'text_quiz_selection_screen.dart';

import 'coming_soon_screen.dart';
import 'profile_selection_screen.dart';
import '../widgets/navigation_utils.dart';
import '../services/audio_service.dart';
import 'bird_id_selection_screen.dart';
import 'word_games_selection_screen.dart';

class MainSelectionScreen extends StatefulWidget {
  const MainSelectionScreen({super.key});

  @override
  State<MainSelectionScreen> createState() => _MainSelectionScreenState();
}

class _MainSelectionScreenState extends State<MainSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playMenuMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _FeatureCard(
                        title: 'Bird Quiz (Text)',
                        icon: Icons.quiz_rounded,
                        color: Colors.teal,
                        description:
                            'Test your knowledge with multiple choice!',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TextQuizSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Bird Identification',
                        icon: Icons.visibility_rounded,
                        color: Colors.orangeAccent.shade700,
                        description:
                            'High Score: ${context.watch<QuizProvider>().birdIdHighScore}/10\nIdentify birds from pictures!',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BirdIdSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Unscramble',
                        icon: Icons.spellcheck_rounded,
                        color: Colors.deepPurpleAccent,
                        description: 'Unscramble and guess the bird words!',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WordGamesSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Bird Sounds',
                        icon: Icons.music_note_rounded,
                        color: Colors.indigoAccent.shade200,
                        description: 'Guess the bird by its call!',
                        isImplemented: false,
                        onTap: () {
                          // TODO: Implement Sound mode
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(title: 'Bird Sounds'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Quiz Challenge',
                        icon: Icons.psychology_rounded,
                        color: Colors.amber.shade700,
                        description: 'Fast-paced trivia challenge!',
                        isImplemented: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ComingSoonScreen(
                                title: 'Quiz Challenge',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Order the Birds',
                        icon: Icons.sort_rounded,
                        color: Colors.lightBlue.shade600,
                        description: 'Sort birds by size, speed, and more!',
                        isImplemented: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ComingSoonScreen(
                                title: 'Order the Birds',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Identify the Eggs',
                        icon: Icons
                            .egg_rounded, // Assuming egg_rounded is available, if not fallback to circle
                        color: Colors.pinkAccent.shade200,
                        description: 'Match the egg to the bird!',
                        isImplemented: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ComingSoonScreen(
                                title: 'Identify the Eggs',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;
  final bool isImplemented;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
    this.isImplemented = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isImplemented ? 1.0 : 0.6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          // height: 120, // Removed fixed height to prevent overflow
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
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

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  NavigationUtils.buildBackButton(
                    context,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileSelectionScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  if (selectedBird != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedBird.color, width: 2),
                      ),
                      child: Text(
                        selectedBird.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          provider.currentProfile?.name ?? 'Adventurer',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NavigationUtils.buildProfileMenu(
                    context,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

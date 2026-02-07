import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import 'quiz_screen.dart';
import '../widgets/navigation_utils.dart'; // Ensure this exists or use logic from other screens

class BirdIdSelectionScreen extends StatelessWidget {
  const BirdIdSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Bird Identification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Can you identify the bird from the photo?',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),
                    // Single Level Card
                    Consumer<QuizProvider>(
                      builder: (context, provider, child) {
                        final highScore = provider.birdIdHighScore;

                        // Calculate stars
                        int stars = 0;
                        if (highScore == 10) {
                          stars = 3;
                        } else if (highScore >= 8) {
                          stars = 2;
                        } else if (highScore >= 5) {
                          stars = 1;
                        }

                        return _LevelCard(
                          title: 'Guess the Bird!',
                          subtitle: 'High Score: $highScore/10',
                          icon: Icons.camera_alt_rounded,
                          color: Colors.orangeAccent.shade700,
                          stars: stars,
                          onTap: () async {
                            final provider = context.read<QuizProvider>();
                            await provider
                                .startBirdIdQuiz(); // This sets _currentCategory to 'bird_id'

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuizScreen(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int stars;
  final VoidCallback onTap;

  const _LevelCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < stars
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: index < stars
                        ? Colors.amber
                        : Colors.white.withValues(alpha: 0.4),
                    size: 32,
                  ),
                );
              }),
            ),
          ],
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
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
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
                  NavigationUtils.buildBackButton(context, color: Colors.white),
                  const SizedBox(width: 4),
                  if (selectedBird != null) ...[
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
                          'Stats',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'Keep going!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    Icons.emoji_events_rounded,
                    '${provider.birdIdHighScore}/10',
                    'High Score',
                    Colors.amber,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.check_circle_rounded,
                    '${provider.currentProfile?.categoryCorrectAnswers['bird_id'] ?? 0}',
                    'Confidence',
                    Colors.greenAccent,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildContainerLine() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

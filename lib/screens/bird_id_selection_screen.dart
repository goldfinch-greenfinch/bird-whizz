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
                    // Theme Levels
                    Expanded(
                      child: ListView(
                        children: const [
                          _ThemeCard(
                            title: 'Waterfowl',
                            icon: Icons.water_drop_rounded,
                            color: Colors.blue,
                          ),
                          _ThemeCard(
                            title: 'Birds of Prey',
                            icon: Icons.bolt_rounded,
                            color: Colors.redAccent,
                          ),
                          _ThemeCard(
                            title: 'Owls',
                            icon: Icons.nightlight_round,
                            color: Colors.deepPurple,
                          ),
                          _ThemeCard(
                            title: 'Waders & Shorebirds',
                            icon: Icons.waves_rounded,
                            color: Colors.cyan,
                          ),
                          _ThemeCard(
                            title: 'Woodpeckers & Kingfishers',
                            icon: Icons.forest_rounded,
                            color: Colors.brown,
                          ),
                          _ThemeCard(
                            title: 'Corvids',
                            icon: Icons.dark_mode_rounded,
                            color: Colors.blueGrey,
                          ),
                          _ThemeCard(
                            title: 'Songbirds',
                            icon: Icons.music_note_rounded,
                            color: Colors.pinkAccent,
                          ),
                          _ThemeCard(
                            title: 'Seabirds',
                            icon: Icons.sailing_rounded,
                            color: Colors.lightBlue,
                          ),
                          _ThemeCard(
                            title: 'Pigeons & Doves',
                            icon: Icons.favorite_rounded,
                            color: Colors.grey,
                          ),
                          _ThemeCard(
                            title: 'Exotic & Colorful',
                            icon: Icons.palette_rounded,
                            color: Colors.orange,
                          ),
                        ],
                      ),
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

class _ThemeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ThemeCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: color,
          collapsedIconColor: color,
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DifficultyButton(
                    title: title,
                    difficulty: 'easy',
                    label: 'Easy',
                    color: Colors.green,
                  ),
                  _DifficultyButton(
                    title: title,
                    difficulty: 'medium',
                    label: 'Medium',
                    color: Colors.orange,
                  ),
                  _DifficultyButton(
                    title: title,
                    difficulty: 'hard',
                    label: 'Hard',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String title;
  final String difficulty;
  final String label;
  final Color color;

  const _DifficultyButton({
    required this.title,
    required this.difficulty,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () async {
        final provider = context.read<QuizProvider>();
        await provider.startBirdIdQuiz(title, difficulty);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizScreen()),
          );
        }
      },
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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

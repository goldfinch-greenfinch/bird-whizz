import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import '../widgets/common_profile_header.dart';
import '../widgets/stat_item_widget.dart';
import '../models/stamp.dart';
import '../screens/achievements_book_screen.dart';

class BirdIdSelectionScreen extends StatelessWidget {
  const BirdIdSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Theme Levels
                        Column(
                          children: const [
                            _ThemeCard(
                              title: 'Waterfowl',
                              icon: Icons.water_drop_rounded,
                              color: Colors.blue,
                              levelCount: 5,
                            ),
                            _ThemeCard(
                              title: 'Coastal & Wading Birds',
                              icon: Icons.waves_rounded,
                              color: Colors.cyan,
                              levelCount: 10,
                            ),
                            _ThemeCard(
                              title: 'Birds of Prey',
                              icon: Icons.bolt_rounded,
                              color: Colors.redAccent,
                              levelCount: 5,
                            ),
                            _ThemeCard(
                              title: 'Forest & Woodland Birds',
                              icon: Icons.forest_rounded,
                              color: Colors.brown,
                              levelCount: 5,
                            ),
                            _ThemeCard(
                              title: 'Exotic & Colorful',
                              icon: Icons.palette_rounded,
                              color: Colors.orange,
                              levelCount: 2,
                            ),
                            _ThemeCard(
                              title: 'Songbirds',
                              icon: Icons.music_note_rounded,
                              color: Colors.pinkAccent,
                              levelCount: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int levelCount;

  const _ThemeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.levelCount,
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(levelCount, (index) {
                  return _DifficultyButton(
                    title: title,
                    difficulty: 'level_${index + 1}',
                    label: 'Level ${index + 1}',
                    color: color,
                  );
                }),
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
          context.read<AudioService>().playTransition();
          context.push(AppRoutes.quiz);
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
        final isExpanded = provider.isBannerExpanded;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            provider.toggleBannerExpanded();
          },
          child: Container(
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
                const CommonProfileHeader(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Column(
                          children: [
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatItemWidget(
                                  icon: Icons.star_rounded,
                                  value:
                                      '${provider.birdIdTotalStars}/${provider.birdIdMaxStars}',
                                  label: 'App Stats',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.emoji_events_rounded,
                                  value: '${provider.birdIdCompletedLevels}/42',
                                  label: 'Levels Done',
                                  color: Colors.orangeAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.check_circle_rounded,
                                  value:
                                      '${provider.currentProfile?.categoryCorrectAnswers['bird_id'] ?? 0}',
                                  label: 'Total Correct',
                                  color: Colors.greenAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.menu_book,
                                  value:
                                      '${provider.unlockedStamps.length}/${gameStamps.length}',
                                  label: 'Badges',
                                  color: Colors.pinkAccent,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AchievementsBookScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

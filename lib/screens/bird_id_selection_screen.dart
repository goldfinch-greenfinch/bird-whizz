import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import '../widgets/common_profile_header.dart';
import '../widgets/stat_item_widget.dart';
import '../widgets/medal_helper.dart';
import '../models/stamp.dart';
import '../screens/achievements_book_screen.dart';

class BirdIdSelectionScreen extends StatefulWidget {
  const BirdIdSelectionScreen({super.key});

  @override
  State<BirdIdSelectionScreen> createState() => _BirdIdSelectionScreenState();
}

class _BirdIdSelectionScreenState extends State<BirdIdSelectionScreen> {
  static const _themes = [
    (title: 'Waterfowl',              icon: Icons.water_drop_rounded, color: Colors.blue,      levelCount: 5),
    (title: 'Coastal & Wading Birds', icon: Icons.waves_rounded,      color: Colors.cyan,      levelCount: 10),
    (title: 'Birds of Prey',          icon: Icons.bolt_rounded,       color: Colors.redAccent, levelCount: 5),
    (title: 'Forest & Woodland Birds',icon: Icons.forest_rounded,     color: Colors.brown,     levelCount: 5),
    (title: 'Exotic & Colorful',      icon: Icons.palette_rounded,    color: Colors.orange,    levelCount: 2),
    (title: 'Songbirds',              icon: Icons.music_note_rounded, color: Colors.pinkAccent,levelCount: 15),
  ];

  late final List<ExpansibleController> _controllers =
      List.generate(_themes.length, (_) => ExpansibleController());

  void _onExpanded(int expandedIndex) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i != expandedIndex) {
        try { _controllers[i].collapse(); } catch (_) {}
      }
    }
  }

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
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 32),
                        Column(
                          children: [
                            for (int i = 0; i < _themes.length; i++)
                              _ThemeCard(
                                title: _themes[i].title,
                                icon: _themes[i].icon,
                                color: _themes[i].color,
                                levelCount: _themes[i].levelCount,
                                controller: _controllers[i],
                                onExpanded: () => _onExpanded(i),
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
  final ExpansibleController controller;
  final VoidCallback onExpanded;

  const _ThemeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.levelCount,
    required this.controller,
    required this.onExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final completedCount = List.generate(levelCount, (i) {
          return provider.birdIdLevelStars(title, 'level_${i + 1}') > 0 ? 1 : 0;
        }).fold<int>(0, (a, b) => a + b);
        final totalStars = List.generate(
          levelCount,
          (i) => provider.birdIdLevelStars(title, 'level_${i + 1}'),
        ).fold<int>(0, (a, b) => a + b);
        final mc = medalColor(totalStars, levelCount * 3);

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
            border: Border.all(
              color: mc ?? color.withValues(alpha: 0.3),
              width: mc != null ? 2 : 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              controller: controller,
              onExpansionChanged: (expanded) { if (expanded) onExpanded(); },
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
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (completedCount > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '$completedCount/$levelCount',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: completedCount == levelCount
                            ? Colors.green[700]
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: completedCount == levelCount
                          ? Colors.green[700]
                          : Colors.amber,
                    ),
                  ],
                  if (mc != null) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.emoji_events_rounded, color: mc, size: 20),
                  ],
                ],
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
      },
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
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final isUnlocked = provider.isBirdIdLevelUnlocked(title, difficulty);
        final stars = provider.birdIdLevelStars(title, difficulty);
        final mc = medalColor(stars);

        final child = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 12,
                      color: Colors.amber,
                    ),
                  ),
                ),
                if (!isUnlocked)
                  Icon(Icons.lock_rounded, size: 13, color: Colors.grey[400])
                else if (mc != null)
                  Icon(Icons.emoji_events_rounded, size: 13, color: mc)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        );

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isUnlocked
                ? color.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.08),
            foregroundColor: isUnlocked ? color : Colors.grey[400],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: mc ?? (isUnlocked ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3)),
                width: mc != null ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: isUnlocked
              ? () async {
                  final provider = context.read<QuizProvider>();
                  await provider.startBirdIdQuiz(title, difficulty);
                  if (context.mounted) {
                    context.read<AudioService>().playTransition();
                    context.push(AppRoutes.quiz);
                  }
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Complete the previous level to unlock!'),
                      duration: Duration(milliseconds: 1500),
                    ),
                  );
                },
          child: child,
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
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
                CommonProfileHeader(
                  expandedStats: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatItemWidget(
                        icon: Icons.star_rounded,
                        value:
                            '${provider.birdIdTotalStars}/${provider.birdIdMaxStars}',
                        label: 'Stars',
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
                            builder: (_) => const AchievementsBookScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

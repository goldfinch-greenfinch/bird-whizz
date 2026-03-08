import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/level.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common_profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: Column(
          children: [
            const _HomeHeader(),
            Expanded(
              child: Consumer<QuizProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView.separated(
                          itemCount: provider.allLevels.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final level = provider.allLevels[index];
                            final isUnlocked =
                                provider.isLevelUnlocked(level.id);
                            final stars =
                                provider.getStarsForLevel(level.id);
                            final color =
                                Color.lerp(
                                  Colors.teal.shade300,
                                  Colors.deepPurple.shade900,
                                  index /
                                      (provider.allLevels.length - 1),
                                ) ??
                                Colors.teal;

                            return _LevelCard(
                              level: level,
                              isUnlocked: isUnlocked,
                              stars: stars,
                              color: color,
                              onTap: () {
                                if (isUnlocked) {
                                  provider.startLevel(level);
                                  context.read<AudioService>().playTransition();
                                  context.push(AppRoutes.quiz);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Get at least 1 star in previous level to unlock!',
                                      ),
                                      duration: Duration(milliseconds: 1500),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CommonProfileHeader(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.star_rounded,
                    '${provider.categoryStars}/${provider.categoryMaxStars}',
                    'Stars',
                    Colors.amber,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.emoji_events_rounded,
                    '${provider.categoryCompletedLevels}/${provider.allLevels.length}',
                    'Levels',
                    Colors.orangeAccent,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.check_circle_rounded,
                    '${provider.categoryTotalCorrectAnswers}',
                    'Total Correct',
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
          style: AppTextStyles.statValue,
        ),
        Text(
          label,
          style: AppTextStyles.statLabel,
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

class _LevelCard extends StatelessWidget {
  final Level level;
  final bool isUnlocked;
  final int stars;
  final Color color;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.stars,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isUnlocked ? color : Colors.grey.shade300;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: cardColor.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? level.iconData : Icons.lock_rounded,
                size: 26,
                color: isUnlocked ? cardColor : Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                  ),
                  if (isUnlocked && stars > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        3,
                        (i) => Icon(
                          i < stars
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ] else if (!isUnlocked) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Complete previous level to unlock',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isUnlocked
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.lock_rounded,
              color: isUnlocked ? Colors.grey[300] : Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

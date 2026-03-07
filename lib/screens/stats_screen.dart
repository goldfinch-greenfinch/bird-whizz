import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/common_profile_header.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String _formatDuration(int totalSeconds) {
    if (totalSeconds < 60) return '$totalSeconds sec';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            final String firstPlay = provider.firstPlayDate != null
                ? DateFormat('MMM d, yyyy').format(provider.firstPlayDate!)
                : 'Unknown';
            final String timePlayed = _formatDuration(
              provider.totalTimePlayingSeconds,
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  const _Header(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                      _StatSection(
                        title: 'Total Journey',
                        icon: Icons.explore_rounded,
                        color: Colors.teal,
                        children: [
                          _StatRow(
                            'Adventurer',
                            provider.currentProfile?.name ?? 'Unknown',
                          ),
                          _StatRow('Rank', provider.userStatusTitle),
                          _StatRow('Started On', firstPlay),
                          _StatRow('Time Played', timePlayed),
                          _StatRow(
                            'Total Stars',
                            '${provider.progressStars} / ${provider.maxStars}',
                          ),
                          const SizedBox(height: 8),
                          if (provider.isMaxCompletion)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.workspace_premium_rounded,
                                    color: Colors.amber,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '100% Complete!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'To Next Rank',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${(provider.nextLevelProgress * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: provider.nextLevelProgress,
                                  backgroundColor: Colors.teal.withValues(
                                    alpha: 0.2,
                                  ),
                                  color: Colors.teal,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatSection(
                        title: 'Text Quiz',
                        icon: Icons.quiz_rounded,
                        color: Colors.blueAccent,
                        children: [
                          _StatRow(
                            'Stars',
                            '${provider.textQuizTotalStars} / ${provider.textQuizMaxStars}',
                          ),
                          _StatRow(
                            'Sections Mastered',
                            '${provider.completedCategoriesCount} / 8',
                          ),
                          _StatRow(
                            'Total Correct',
                            '${provider.totalCorrectAnswers}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatSection(
                        title: 'Bird Identification',
                        icon: Icons.visibility_rounded,
                        color: Colors.orangeAccent.shade700,
                        children: [
                          _StatRow(
                            'Stars',
                            '${provider.birdIdTotalStars} / ${provider.birdIdMaxStars}',
                          ),
                          _StatRow(
                            'Best Session Score',
                            '${provider.birdIdHighScore} / 10',
                          ),
                          _StatRow(
                            'Total Identified',
                            '${provider.currentProfile?.categoryCorrectAnswers['bird_id'] ?? 0}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatSection(
                        title: 'Word Games',
                        icon: Icons.spellcheck_rounded,
                        color: Colors.deepPurpleAccent,
                        children: [
                          _StatRow(
                            'Unscramble Stars',
                            '${provider.unscrambleTotalStars} / ${provider.unscrambleMaxStars}',
                          ),
                          _StatRow(
                            'Best Unscramble Score',
                            '${provider.unscrambleHighScore} / 10',
                          ),
                          _StatRow(
                            'Words Unscrambled',
                            '${provider.totalUnscrambledWords}',
                          ),
                          _StatRow(
                            'Crossbird Stars',
                            '${provider.crossbirdTotalStars} / ${provider.crossbirdMaxStars}',
                          ),
                          _StatRow(
                            'Crosswords Solved',
                            '${provider.totalCrosswordsSolved}',
                          ),
                          _StatRow(
                            'Rescue Stars',
                            '${provider.rescueTotalStars} / ${provider.rescueMaxStars}',
                          ),
                          _StatRow(
                            'Birds Rescued',
                            '${provider.totalRescuedBirds}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatSection(
                        title: 'Special Modes',
                        icon: Icons.auto_awesome_rounded,
                        color: Colors.indigo,
                        children: [
                          _StatRow(
                            'Guess the Bird Stars',
                            '${provider.guessBirdTotalStars} / ${provider.guessBirdMaxStars}',
                          ),
                          _StatRow(
                            'Speed Challenge Stars',
                            '${provider.speedChallengeTotalStars} / ${provider.speedChallengeMaxStars}',
                          ),
                          _StatRow(
                            'Endless Best Streak',
                            '${provider.endlessHighScore}',
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _StatSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: children
                  .map(
                    (child) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: child,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
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
            children: [const CommonProfileHeader(isStatsScreen: true, sectionTitle: 'My Stats')],
          ),
        );
      },
    );
  }
}

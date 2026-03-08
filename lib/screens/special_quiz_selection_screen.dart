import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/guess_bird_data.dart';
import '../data/speed_challenge_data.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/common_profile_header.dart';

class SpecialQuizSelectionScreen extends StatelessWidget {
  const SpecialQuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
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
                    Text(
                      'Special Quiz Modes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Challenge yourself with these unique game modes.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    _GameCard(
                      title: 'Survival Mode',
                      subtitle:
                          'Answer as many questions as you can. Three strikes and you\'re out!',
                      icon: Icons.local_fire_department_rounded,
                      color: Colors.redAccent,
                      onTap: () {
                        final provider = context.read<QuizProvider>();
                        provider.startEndlessMode();
                        context.read<AudioService>().playTransition();
                        context.push(AppRoutes.endless);
                      },
                    ),
                    const SizedBox(height: 20),
                    _GameCard(
                      title: 'Guess the Bird',
                      subtitle:
                          'Read a description and type the bird\'s name. Then see its photo!',
                      icon: Icons.psychology_rounded,
                      color: Colors.indigo,
                      onTap: () {
                        context.read<AudioService>().playUiTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _GuessBirdLevelsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _GameCard(
                      title: 'Speed Challenge',
                      subtitle:
                          'Race the clock! Mix of trivia and bird ID — 5 levels, each faster than the last.',
                      icon: Icons.speed_rounded,
                      color: const Color(0xFFE65100),
                      onTap: () {
                        context.read<AudioService>().playUiTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _SpeedChallengeLevelsScreen(),
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
      ),
    );
  }
}

// ─── Shared header for Special Quiz Modes ───────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: Colors.indigo[700],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CommonProfileHeader(sectionTitle: 'Special Quiz Modes'),
              const SizedBox(height: 20),
              // Shared stats bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.local_fire_department_rounded,
                    '${provider.endlessHighScore}',
                    'Best Streak',
                    Colors.orangeAccent,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.psychology_rounded,
                    '${provider.guessBirdCompletedLevels}/5',
                    'Guess Lvls',
                    Colors.lightBlueAccent,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.speed_rounded,
                    '${provider.speedChallengeCompletedLevels}/5',
                    'Speed Lvls',
                    const Color(0xFFFF8A65),
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.star_rounded,
                    '${provider.speedChallengeTotalStars}/${provider.speedChallengeMaxStars}',
                    'Speed Stars',
                    Colors.amber,
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
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
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

  Widget _buildDivider() => Container(
        height: 30,
        width: 1,
        color: Colors.white.withValues(alpha: 0.2),
      );
}

// ─── Game selection card ─────────────────────────────────────────────────────

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
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
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Guess the Bird level selection screen ───────────────────────────────────

class _GuessBirdLevelsScreen extends StatelessWidget {
  const _GuessBirdLevelsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView.separated(
                  itemCount: guessBirdLevels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _buildLevelCard(context, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: Colors.indigo[700],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CommonProfileHeader(sectionTitle: 'Guess the Bird'),
              const SizedBox(height: 20),
              // Guess the Bird specific stats bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    Icons.star_rounded,
                    '${provider.guessBirdTotalStars}/${provider.guessBirdMaxStars}',
                    'Stars',
                    Colors.amber,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.emoji_events_rounded,
                    '${provider.guessBirdCompletedLevels}/5',
                    'Levels Done',
                    Colors.orangeAccent,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.check_circle_rounded,
                    '${provider.guessBirdTotalGuessed}',
                    'Birds Guessed',
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

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
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

  Widget _buildDivider() => Container(
        height: 30,
        width: 1,
        color: Colors.white.withValues(alpha: 0.2),
      );

  Widget _buildLevelCard(BuildContext context, int index) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final levelId = 'guess_bird_level_$index';
        final stars = provider.levelStars(levelId);
        final level = guessBirdLevels[index];

        return InkWell(
          onTap: () {
            context.read<AudioService>().playTransition();
            context.push('${AppRoutes.special}/guess-bird/$index');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.indigo.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Level emoji
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${index + 1}: ${level.title}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (stars > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            3,
                            (i) => Icon(
                              i < stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[300],
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Speed Challenge level selection screen ──────────────────────────────────

class _SpeedChallengeLevelsScreen extends StatelessWidget {
  const _SpeedChallengeLevelsScreen();

  static const Color _accent = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView.separated(
                  itemCount: speedChallengeLevels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _buildLevelCard(context, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CommonProfileHeader(sectionTitle: 'Speed Challenge'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    Icons.star_rounded,
                    '${provider.speedChallengeTotalStars}/${provider.speedChallengeMaxStars}',
                    'Stars',
                    Colors.amber,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.emoji_events_rounded,
                    '${provider.speedChallengeCompletedLevels}/5',
                    'Levels Done',
                    Colors.orangeAccent,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.check_circle_rounded,
                    '${provider.speedChallengeTotalCorrect}',
                    'Correct',
                    Colors.lightGreenAccent,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
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

  Widget _buildDivider() => Container(
        height: 30,
        width: 1,
        color: Colors.white.withValues(alpha: 0.25),
      );

  Widget _buildLevelCard(BuildContext context, int index) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final levelId = 'speed_challenge_level_$index';
        final stars = provider.levelStars(levelId);
        final level = speedChallengeLevels[index];

        return InkWell(
          onTap: () {
            context.read<AudioService>().playTransition();
            context.push('${AppRoutes.special}/speed-challenge/$index');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: _accent.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Level ${index + 1}: ${level.title}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_rounded,
                                  size: 13,
                                  color: _accent,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${level.secondsPerQuestion}s',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (stars > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            3,
                            (i) => Icon(
                              i < stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[300],
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

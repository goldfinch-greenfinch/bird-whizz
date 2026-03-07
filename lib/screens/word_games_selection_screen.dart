import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import 'unscramble_game_screen.dart';
import 'rescue_bird_screen.dart';
import 'crossbird_screen.dart';
import '../widgets/common_profile_header.dart';

class WordGamesSelectionScreen extends StatelessWidget {
  const WordGamesSelectionScreen({super.key});

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
                child: ListView(
                  children: [
                    const Text(
                      'Bird Word Games',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Relaxing, no-fail bird word challenges.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    _GameCard(
                      title: 'Unscramble',
                      subtitle: 'Rearrange the letters to find the bird.',
                      icon: Icons.spellcheck_rounded,
                      color: Colors.deepPurpleAccent,
                      onTap: () {
                        context.read<AudioService>().playUiTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _UnscrambleLevelsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _GameCard(
                      title: 'Rescue the Bird',
                      subtitle:
                          'Guess letters to crack the egg and free the bird.',
                      icon: Icons.egg_rounded,
                      color: Colors.orangeAccent,
                      onTap: () {
                        context.read<AudioService>().playTransition();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RescueBirdScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _GameCard(
                      title: 'Crossbird',
                      subtitle:
                          'Mini crosswords with bird facts as clues.',
                      icon: Icons.grid_on_rounded,
                      color: Colors.teal,
                      onTap: () {
                        context.read<AudioService>().playUiTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _CrossbirdLevelsScreen(),
                          ),
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

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.trailing,
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
              child: Icon(icon, color: color, size: 48),
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
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300]),
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
              const CommonProfileHeader(sectionTitle: 'Bird Word Games'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.star_rounded,
                    '${provider.wordGamesTotalStars}/${provider.wordGamesMaxStars}',
                    'Word Stars',
                    Colors.amber,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.emoji_events_rounded,
                    '${provider.unscrambleCompletedLevels + provider.rescueCompletedLevels + provider.crossbirdCompletedPuzzles}',
                    'Levels Done',
                    Colors.orangeAccent,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.grid_on_rounded,
                    '${provider.crossbirdTotalStars}/${provider.crossbirdMaxStars}',
                    'Cross Stars',
                    Colors.tealAccent,
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

class _CrossbirdLevelsScreen extends StatelessWidget {
  const _CrossbirdLevelsScreen();

  static const _puzzleTitles = [
    'Night & Day',
    'Woodland & Shore',
    'Meadow & Heath',
    'World Birds',
  ];
  static const _puzzleSubtitles = [
    'Six birds spanning dusk to dawn — from Wren to Nightjar',
    'Six birds of wood, wetland and estuary to discover',
    'Five birds of meadow, heath and open skies',
    'Five birds from across the globe — from Quetzal to Loon',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView.separated(
                  itemCount: _puzzleTitles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _buildPuzzleCard(context, index),
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
              const CommonProfileHeader(sectionTitle: 'Cross-Bird Puzzles'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    Icons.star_rounded,
                    '${provider.crossbirdTotalStars}/${provider.crossbirdMaxStars}',
                    'Stars',
                    Colors.amber,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.grid_on_rounded,
                    '${provider.crossbirdCompletedPuzzles}/4',
                    'Puzzles Done',
                    Colors.tealAccent,
                  ),
                  _buildDivider(),
                  _buildStat(
                    Icons.check_circle_rounded,
                    '${provider.totalCrosswordsSolved}',
                    'Words Solved',
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

  Widget _buildPuzzleCard(BuildContext context, int index) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final levelKey = 'crossbird_puzzle_$index';
        final stars = provider.levelStars(levelKey);
        return _GameCard(
          title: 'Puzzle ${index + 1}: ${_puzzleTitles[index]}',
          subtitle: _puzzleSubtitles[index],
          icon: Icons.grid_on_rounded,
          color: Colors.teal,
          trailing: stars > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                )
              : null,
          onTap: () {
            context.read<AudioService>().playTransition();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CrossbirdScreen(puzzleIndex: index),
              ),
            ).then((_) {
              if (context.mounted) {
                context.read<AudioService>().playMenuMusic();
              }
            });
          },
        );
      },
    );
  }
}

class _UnscrambleLevelsScreen extends StatelessWidget {
  const _UnscrambleLevelsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  children: [
                    _buildLevelCard(
                      context,
                      'Level 1: Short Words',
                      '3-4 Letters',
                      1,
                      4,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      'Level 2: Fledglings',
                      '5-6 Letters',
                      5,
                      6,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      'Level 3: Winging It',
                      '7-8 Letters',
                      7,
                      8,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      'Level 4: High Flyer',
                      '9-10 Letters',
                      9,
                      10,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      'Level 5: Master',
                      '11+ Letters',
                      11,
                      100,
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

  Widget _buildHeader(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CommonProfileHeader(sectionTitle: 'Bird Unscramble'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.star_rounded,
                    '${provider.unscrambleTotalStars}/${provider.unscrambleMaxStars}',
                    'Stars',
                    Colors.amber,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.emoji_events_rounded,
                    '${provider.unscrambleCompletedLevels}',
                    'Levels Done',
                    Colors.orangeAccent,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    Icons.spellcheck_rounded,
                    '${provider.totalUnscrambledWords}',
                    'Words Solved',
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

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
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

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String title,
    String subtitle,
    int minLength,
    int maxLength,
  ) {
    return _GameCard(
      title: title,
      subtitle: subtitle,
      icon: Icons.spellcheck_rounded,
      color: Colors.deepPurpleAccent,
      onTap: () {
        context.read<AudioService>().playTransition();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UnscrambleGameScreen(
              title: title,
              minLength: minLength,
              maxLength: maxLength,
            ),
          ),
        ).then((_) {
          if (context.mounted) {
            context.read<AudioService>().playMenuMusic();
          }
        });
      },
    );
  }
}

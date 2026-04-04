import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import 'unscramble_game_screen.dart';
import 'crossbird_screen.dart';
import '../widgets/common_profile_header.dart';
import '../widgets/stat_item_widget.dart';
import '../models/stamp.dart';
import '../screens/achievements_book_screen.dart';

class WordGamesSelectionScreen extends StatelessWidget {
  const WordGamesSelectionScreen({super.key});

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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
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
                            context.push('${AppRoutes.wordGames}/rescue');
                          },
                        ),
                        const SizedBox(height: 20),
                        _GameCard(
                          title: 'Crossbird',
                          subtitle: 'Mini crosswords with bird facts as clues.',
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
              ),
            ],
          ),
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
            trailing ??
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300]),
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
                                      '${provider.wordGamesTotalStars}/${provider.wordGamesMaxStars}',
                                  label: 'Word Stars',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.emoji_events_rounded,
                                  value:
                                      '${provider.unscrambleCompletedLevels + provider.rescueCompletedLevels + provider.crossbirdCompletedPuzzles}',
                                  label: 'Levels Done',
                                  color: Colors.orangeAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.grid_on_rounded,
                                  value:
                                      '${provider.crossbirdTotalStars}/${provider.crossbirdMaxStars}',
                                  label: 'Cross Stars',
                                  color: Colors.tealAccent,
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
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 8),
              child: Column(
                children: [
                  Text(
                    'Cross-Bird Puzzles',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mini crosswords with bird facts as clues.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: ListView.separated(
                  itemCount: _puzzleTitles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatItemWidget(
                                  icon: Icons.star_rounded,
                                  value:
                                      '${provider.crossbirdTotalStars}/${provider.crossbirdMaxStars}',
                                  label: 'Stars',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.grid_on_rounded,
                                  value:
                                      '${provider.crossbirdCompletedPuzzles}/4',
                                  label: 'Puzzles Done',
                                  color: Colors.tealAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.check_circle_rounded,
                                  value: '${provider.totalCrosswordsSolved}',
                                  label: 'Words Solved',
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

  Widget _buildPuzzleCard(BuildContext context, int index) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final levelKey = 'crossbird_puzzle_$index';
        final stars = provider.levelStars(levelKey);
        final isUnlocked = provider.isCrossbirdPuzzleUnlocked(index);

        Widget trailing;
        if (!isUnlocked) {
          trailing = Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: Colors.grey, size: 20),
          );
        } else if (stars > 0) {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: Colors.amber,
                size: 20,
              ),
            ),
          );
        } else {
          trailing = Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300]);
        }

        return Opacity(
          opacity: isUnlocked ? 1.0 : 0.5,
          child: _GameCard(
            title: 'Puzzle ${index + 1}: ${_puzzleTitles[index]}',
            subtitle: isUnlocked
                ? _puzzleSubtitles[index]
                : 'Complete Puzzle $index to unlock',
            icon: isUnlocked ? Icons.grid_on_rounded : Icons.lock_rounded,
            color: isUnlocked ? Colors.teal : Colors.grey,
            trailing: trailing,
            onTap: () {
              if (!isUnlocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complete the previous puzzle to unlock!'),
                    duration: Duration(milliseconds: 1500),
                  ),
                );
                return;
              }
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
          ),
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
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 8),
              child: Column(
                children: [
                  Text(
                    'Bird Unscramble',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rearrange the letters to find the bird.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: ListView(
                  children: [
                    _buildLevelCard(context, 0, 'Level 1: Short Words', '3-4 Letters', 1, 4),
                    const SizedBox(height: 16),
                    _buildLevelCard(context, 1, 'Level 2: Fledglings', '5-6 Letters', 5, 6),
                    const SizedBox(height: 16),
                    _buildLevelCard(context, 2, 'Level 3: Winging It', '7-8 Letters', 7, 8),
                    const SizedBox(height: 16),
                    _buildLevelCard(context, 3, 'Level 4: High Flyer', '9-10 Letters', 9, 10),
                    const SizedBox(height: 16),
                    _buildLevelCard(context, 4, 'Level 5: Master', '11+ Letters', 11, 100),
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
        final isExpanded = provider.isBannerExpanded;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            provider.toggleBannerExpanded();
          },
          child: Container(
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
                const CommonProfileHeader(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatItemWidget(
                                  icon: Icons.star_rounded,
                                  value:
                                      '${provider.unscrambleTotalStars}/${provider.unscrambleMaxStars}',
                                  label: 'Stars',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.emoji_events_rounded,
                                  value:
                                      '${provider.unscrambleCompletedLevels}',
                                  label: 'Levels Done',
                                  color: Colors.orangeAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.spellcheck_rounded,
                                  value: '${provider.totalUnscrambledWords}',
                                  label: 'Words Solved',
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

  Widget _buildLevelCard(
    BuildContext context,
    int levelIndex,
    String title,
    String subtitle,
    int minLength,
    int maxLength,
  ) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final isUnlocked = provider.isUnscrambleLevelUnlocked(levelIndex);
        final stars = provider.unscrambleLevelStars(levelIndex);

        Widget trailing;
        if (!isUnlocked) {
          trailing = Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: Colors.grey, size: 20),
          );
        } else if (stars > 0) {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: Colors.amber,
                size: 20,
              ),
            ),
          );
        } else {
          trailing = Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300]);
        }

        return Opacity(
          opacity: isUnlocked ? 1.0 : 0.5,
          child: _GameCard(
            title: title,
            subtitle: isUnlocked ? subtitle : 'Complete Level $levelIndex to unlock',
            icon: isUnlocked ? Icons.spellcheck_rounded : Icons.lock_rounded,
            color: isUnlocked ? Colors.deepPurpleAccent : Colors.grey,
            trailing: trailing,
            onTap: () {
              if (!isUnlocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complete the previous level to unlock!'),
                    duration: Duration(milliseconds: 1500),
                  ),
                );
                return;
              }
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
          ),
        );
      },
    );
  }
}

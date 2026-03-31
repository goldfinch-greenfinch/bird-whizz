import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/common_profile_header.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_item_widget.dart';
import '../models/stamp.dart';
import '../screens/achievements_book_screen.dart';

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
      if (!mounted) return;
      context.read<AudioService>().playMenuMusic();

      final provider = Provider.of<QuizProvider>(context, listen: false);
      if (provider.isDailyChallengeAvailable &&
          !provider.hasShownDailyChallengeThisSession) {
        provider.markDailyChallengeShown();

        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _launchDailyChallenge(context, provider);
          }
        });
      }
    });
  }

  void _launchDailyChallenge(BuildContext screenContext, QuizProvider provider) {
    showGeneralDialog(
      context: screenContext,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, anim1, anim2) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut)),
          child: AlertDialog(
            backgroundColor: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Daily Challenge!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.star,
              ),
            ),
            content: const Text(
              'A new bird challenge awaits you!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Use the screen context (not the dialog's context) so navigation
                  // happens from a live route after the dialog dismisses.
                  dialogContext.pop();
                  provider.startDailyChallenge();
                  screenContext.read<AudioService>().playTransition();
                  screenContext.push(AppRoutes.quiz);
                },
                child: const Text(
                  'Play Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDebugMenu(BuildContext context) {
    final provider = context.read<QuizProvider>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Debug: Test Level-Up Flow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current stars: ${provider.progressStars}  '
              'Level: ${provider.userLevelIndex}  '
              'Evo: ${provider.userEvolutionStage}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.debugForceLevelUp();
                ctx.pop();
                context.pushReplacement(AppRoutes.result);
              },
              child: const Text('Result → Level Up'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                provider.debugForceLevelUp(includeEvolve: true);
                ctx.pop();
                context.pushReplacement(AppRoutes.result);
              },
              child: const Text('Result → Level Up → Evolve'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                provider.debugForceLevelUp(includeEvolve: true);
                provider.consumeLevelUp();
                ctx.pop();
                context.pushReplacement(AppRoutes.evolve);
              },
              child: const Text('Evolve screen only'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                provider.debugQueueAllEvolutions();
                ctx.pop();
                context.pushReplacement(AppRoutes.evolve);
              },
              child: const Text(
                'Loop all evolutions (1→2→3→4→5)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
              onPressed: () {
                ctx.pop();
                context.push(AppRoutes.allStars);
              },
              child: const Text(
                'All Stars celebration screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]),
              onPressed: () {
                ctx.pop();
                context.push(AppRoutes.allBadges);
              },
              child: const Text(
                'All Badges celebration screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              onPressed: () => _showDebugMenu(context),
              backgroundColor: Colors.red[700],
              tooltip: 'Debug: test level-up',
              child: const Icon(Icons.bug_report, color: Colors.white),
            )
          : null,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Main Menu',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a game to play and learn about birds!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Consumer<QuizProvider>(
                          builder: (context, provider, child) {
                            if (!provider.isDailyChallengeAvailable) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: InkWell(
                                onTap: () {
                                  _launchDailyChallenge(context, provider);
                                },
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.shade300,
                                        Colors.orange.shade400,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Daily Bird Challenge',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              'Tap to play today\'s challenge!',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Bird Whizz',
                          icon: Icons.quiz_rounded,
                          color: AppColors.primary,
                          description:
                              'Test your knowledge with multiple choice!',
                          onTap: () {
                            context.read<AudioService>().playUiTap();
                            context.push(AppRoutes.textQuiz);
                          },
                        ),
                        const SizedBox(height: 24),
                        _FeatureCard(
                          title: 'Bird Identification',
                          icon: Icons.visibility_rounded,
                          color: AppColors.birdId,
                          description: 'Identify birds from pictures!',
                          onTap: () {
                            context.read<AudioService>().playUiTap();
                            context.push(AppRoutes.birdId);
                          },
                        ),
                        const SizedBox(height: 24),
                        _FeatureCard(
                          title: 'Bird Word Games',
                          icon: Icons.spellcheck_rounded,
                          color: AppColors.wordGames,
                          description:
                              'Unscramble birds, rescue them from nests or solve cross-birds!',
                          onTap: () {
                            context.read<AudioService>().playUiTap();
                            context.push(AppRoutes.wordGames);
                          },
                        ),
                        const SizedBox(height: 24),
                        _FeatureCard(
                          title: 'Special Quiz Modes',
                          icon: Icons.auto_awesome_rounded,
                          color: AppColors.guessBird,
                          description:
                              'Survival Mode & Guess the Bird — unique challenges!',
                          onTap: () {
                            context.read<AudioService>().playUiTap();
                            context.push(AppRoutes.special);
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

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                CommonProfileHeader(
                  onBackButtonPressed: () {
                    context.go(AppRoutes.profiles);
                  },
                ),
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
                                  icon: Icons.quiz_rounded,
                                  value:
                                      '${provider.textQuizTotalStars}/${provider.textQuizMaxStars}',
                                  label: 'Quiz',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.visibility_rounded,
                                  value:
                                      '${provider.birdIdTotalStars}/${provider.birdIdMaxStars}',
                                  label: 'Bird ID',
                                  color: Colors.orangeAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.spellcheck_rounded,
                                  value:
                                      '${provider.wordGamesTotalStars}/${provider.wordGamesMaxStars}',
                                  label: 'Words',
                                  color: Colors.tealAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.auto_awesome_rounded,
                                  value:
                                      '${provider.speedChallengeTotalStars + provider.guessBirdTotalStars}/${provider.speedChallengeMaxStars + provider.guessBirdMaxStars}',
                                  label: 'Special',
                                  color: Colors.lightBlueAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.menu_book,
                                  value:
                                      '${provider.unlockedStamps.length}/${gameStamps.length}',
                                  label: 'Badges',
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AchievementsBookScreen(),
                                      ),
                                    );
                                  },
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/user_level_badge.dart';
import '../screens/stats_screen.dart';

class CommonProfileHeader extends StatelessWidget {
  final VoidCallback? onBackButtonPressed;
  final bool isStatsScreen;
  final Widget? expandedStats;
  const CommonProfileHeader({
    super.key,
    this.onBackButtonPressed,
    this.isStatsScreen = false,
    this.expandedStats,
  });

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

        final isExpanded = provider.isBannerExpanded;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            provider.toggleBannerExpanded();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  NavigationUtils.buildBackButton(
                    context,
                    color: Colors.white,
                    onPressed: onBackButtonPressed,
                  ),
                  if (selectedBird != null) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        if (!isStatsScreen) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StatsScreen(),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: provider.isMaxCompletion
                                    ? Colors.amber
                                    : selectedBird.color,
                                width: provider.isMaxCompletion ? 3.5 : 3,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                selectedBird.getEvolvedImagePath(
                                  provider.userEvolutionStage,
                                ),
                                width:
                                    (MediaQuery.of(context).size.width * 0.16)
                                        .clamp(60.0, 96.0),
                                height:
                                    (MediaQuery.of(context).size.width * 0.16)
                                        .clamp(60.0, 96.0),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (provider.isMaxCompletion)
                            Positioned(
                              top: -10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Icon(
                                  Icons.workspace_premium_rounded,
                                  color: Colors.amber,
                                  size: 22,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else
                    const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.currentProfile?.name ??
                                          'Adventurer',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [const Expanded(child: UserLevelBadge())],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'level ${provider.isMaxCompletion ? '100' : (provider.nextLevelProgress * 100).toStringAsFixed(0)}% complete',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!provider.isMaxCompletion)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${provider.currentStarsInLevel}/${provider.neededStarsForNextLevel}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 12,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: provider.isMaxCompletion
                                ? 1.0
                                : provider.nextLevelProgress.clamp(0.0, 1.0),
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            color: Colors.yellowAccent,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: (MediaQuery.of(context).size.width * 0.16).clamp(
                      60.0,
                      96.0,
                    ),
                    alignment: Alignment.topRight,
                    child: NavigationUtils.buildProfileMenu(
                      context,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (expandedStats != null) ...[
                            const SizedBox(height: 20),
                            expandedStats!,
                          ],
                          const SizedBox(height: 6),
                          Text(
                            'game ${provider.maxStars > 0 ? (provider.progressStars / provider.maxStars * 100).toStringAsFixed(0) : 0}% complete',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: provider.maxStars > 0
                                  ? (provider.progressStars / provider.maxStars)
                                        .clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              color: Colors.greenAccent,
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

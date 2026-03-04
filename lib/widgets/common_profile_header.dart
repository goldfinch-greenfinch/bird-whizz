import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/user_level_badge.dart';
import '../screens/stats_screen.dart';
import '../screens/achievements_book_screen.dart';

class CommonProfileHeader extends StatelessWidget {
  final VoidCallback? onBackButtonPressed;
  final bool isStatsScreen;

  const CommonProfileHeader({
    super.key,
    this.onBackButtonPressed,
    this.isStatsScreen = false,
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

        return Row(
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
                      MaterialPageRoute(builder: (_) => const StatsScreen()),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: selectedBird.color, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      selectedBird.getEvolvedImagePath(
                        provider.userEvolutionStage,
                      ),
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else
              const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!isStatsScreen) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatsScreen()),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentProfile?.name ?? 'Adventurer',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment
                          .end, // Aligns base of badge and icon
                      children: [
                        const Flexible(child: UserLevelBadge()),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.menu_book,
                            color: Colors.amber,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AchievementsBookScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 68,
              alignment: Alignment.topRight,
              child: NavigationUtils.buildProfileMenu(
                context,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

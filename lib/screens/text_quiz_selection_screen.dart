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

class TextQuizSelectionScreen extends StatelessWidget {
  const TextQuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            const _CategoryHeader(),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 8),
              child: Column(
                children: [
                  Text(
                    'Bird Whizz',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Test your bird knowledge!',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<QuizProvider>(
                  builder: (context, provider, child) {
                    final categories = [
                      {
                        'id': 'trivia',
                        'title': 'Bird Trivia',
                        'icon': Icons.quiz_rounded,
                        'description': 'Test your general bird knowledge!',
                      },
                      {
                        'id': 'habitat',
                        'title': 'Habitat & Geography',
                        'icon': Icons.public_rounded,
                        'description': 'Where do they live?',
                      },
                      {
                        'id': 'behaviour',
                        'title': 'Bird Behaviour',
                        'icon': Icons.psychology_outlined,
                        'description': 'What are they doing?',
                      },
                      {
                        'id': 'colours',
                        'title': 'Bird Colours',
                        'icon': Icons.palette,
                        'description': 'Nature\'s palette.',
                      },
                      {
                        'id': 'families',
                        'title': 'Bird Families',
                        'icon': Icons.family_restroom,
                        'description': 'Who is related to whom?',
                      },
                      {
                        'id': 'migration',
                        'title': 'Bird Migration',
                        'icon': Icons.flight_takeoff,
                        'description': 'The great journeys.',
                      },
                      {
                        'id': 'biology',
                        'title': 'Bird Biology',
                        'icon': Icons.biotech_outlined,
                        'description': 'Anatomy, feathers and more!',
                      },
                      {
                        'id': 'conservation',
                        'title': 'Conservation',
                        'icon': Icons.eco_rounded,
                        'description': 'Protecting our feathered friends.',
                      },
                    ];

                    return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final color =
                            Color.lerp(
                              Colors.teal.shade300,
                              Colors.deepPurple.shade900,
                              index / (categories.length - 1),
                            ) ??
                            Colors.teal;
                        final stars = provider.getSectionStarRating(
                          cat['id'] as String,
                        );

                        return InkWell(
                          onTap: () {
                            context.read<AudioService>().playUiTap();
                            provider.selectCategory(cat['id'] as String);
                            context.push(AppRoutes.textQuizLevels);
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: color.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: color,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
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
                    ),
                  ),
                );
                },
              ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader();

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
                                      '${provider.totalStars}/${provider.maxStars}',
                                  label: 'App Stats',
                                  color: Colors.amber,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.emoji_events_rounded,
                                  value:
                                      '${provider.completedCategoriesCount}/${provider.allLevels.isNotEmpty ? 8 : 0}',
                                  label: 'Sections Done',
                                  color: Colors.orangeAccent,
                                ),
                                buildStatDivider(),
                                StatItemWidget(
                                  icon: Icons.check_circle_rounded,
                                  value: '${provider.totalCorrectAnswers}',
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

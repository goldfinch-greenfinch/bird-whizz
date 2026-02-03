import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/bird.dart';
import 'home_screen.dart';

import '../widgets/navigation_utils.dart';

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

                    return GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        // Gradient from Teal 300 to Teal 900
                        final color =
                            Color.lerp(
                              Colors.teal.shade300,
                              Colors.teal.shade900,
                              index / (categories.length - 1),
                            ) ??
                            Colors.teal;

                        return _CategoryCard(
                          title: cat['title'] as String,
                          icon: cat['icon'] as IconData,
                          color: color,
                          description: cat['description'] as String,
                          starRating: provider.getSectionStarRating(
                            cat['id'] as String,
                          ),
                          onTap: () {
                            provider.selectCategory(cat['id'] as String);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                        );
                      },
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
              Row(
                children: [
                  NavigationUtils.buildBackButton(context, color: Colors.white),
                  const SizedBox(width: 4),
                  if (selectedBird != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedBird.color, width: 2),
                      ),
                      child: Text(
                        selectedBird.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bird Quiz',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'Choose a category!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NavigationUtils.buildProfileMenu(
                    context,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.star_rounded,
                    '${provider.totalStars}/${provider.maxStars}',
                    'App Stats',
                    Colors.amber,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.emoji_events_rounded,
                    '${provider.completedCategoriesCount}/${provider.allLevels.isNotEmpty ? 8 : 0}', // Hardcoded 8 sections for now + bonus maybe? Let's use 8 from _categoryOrder
                    'Sections Done',
                    Colors.orangeAccent,
                  ),
                  _buildContainerLine(),
                  _buildStatItem(
                    Icons.check_circle_rounded,
                    '${provider.totalCorrectAnswers}',
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

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;
  final int starRating;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
    this.starRating = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            if (starRating > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < starRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: index < starRating
                        ? Colors.amber
                        : Colors.white.withValues(alpha: 0.5),
                    size: 16,
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

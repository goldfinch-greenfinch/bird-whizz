import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import 'home_screen.dart';
import '../widgets/common_profile_header.dart';

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

                    return ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 14),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(18),
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
                              border: Border.all(
                                color: color.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: color,
                                    size: 28,
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
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cat['description'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      if (stars > 0) ...[
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
              const CommonProfileHeader(sectionTitle: 'Bird Whizz'),
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


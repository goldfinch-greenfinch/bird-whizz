import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/common_profile_header.dart';
import 'text_quiz_selection_screen.dart';

import 'profile_selection_screen.dart';
import '../services/audio_service.dart';
import 'bird_id_selection_screen.dart';
import 'word_games_selection_screen.dart';
import 'quiz_screen.dart';
import 'special_quiz_selection_screen.dart';

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

  void _launchDailyChallenge(BuildContext context, QuizProvider provider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
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
                color: Colors.amber,
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
                  Navigator.pop(context); // close dialog
                  provider.startDailyChallenge();
                  context.read<AudioService>().playTransition();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizScreen()),
                  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        color: Colors.teal,
                        description:
                            'Test your knowledge with multiple choice!',
                        onTap: () {
                          context.read<AudioService>().playUiTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TextQuizSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Bird Identification',
                        icon: Icons.visibility_rounded,
                        color: Colors.orangeAccent.shade700,
                        description: 'Identify birds from pictures!',
                        onTap: () {
                          context.read<AudioService>().playUiTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BirdIdSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Bird Word Games',
                        icon: Icons.spellcheck_rounded,
                        color: Colors.deepPurpleAccent,
                        description:
                            'Unscramble birds, rescue them from nests or solve cross-birds!',
                        onTap: () {
                          context.read<AudioService>().playUiTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WordGamesSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _FeatureCard(
                        title: 'Special Quiz Modes',
                        icon: Icons.auto_awesome_rounded,
                        color: Colors.indigo,
                        description:
                            'Survival Mode & Guess the Bird — unique challenges!',
                        onTap: () {
                          context.read<AudioService>().playUiTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SpecialQuizSelectionScreen(),
                            ),
                          );
                        },
                      ),
                  ],
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
              CommonProfileHeader(
                onBackButtonPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileSelectionScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.quiz_rounded, '${provider.textQuizTotalStars}/${provider.textQuizMaxStars}', 'Quiz', Colors.amber),
                  _buildDivider(),
                  _buildStatItem(Icons.visibility_rounded, '${provider.birdIdTotalStars}/${provider.birdIdMaxStars}', 'Bird ID', Colors.orangeAccent),
                  _buildDivider(),
                  _buildStatItem(Icons.spellcheck_rounded, '${provider.wordGamesTotalStars}/${provider.wordGamesMaxStars}', 'Words', Colors.tealAccent),
                  _buildDivider(),
                  _buildStatItem(Icons.auto_awesome_rounded, '${provider.speedChallengeTotalStars + provider.guessBirdTotalStars}/${provider.speedChallengeMaxStars + provider.guessBirdMaxStars}', 'Special', Colors.lightBlueAccent),
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
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
      ],
    );
  }

  Widget _buildDivider() => Container(height: 30, width: 1, color: Colors.white.withValues(alpha: 0.2));
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/about/app_text.dart';
import '../data/about/feedback_text.dart';
import '../data/about/mission_text.dart';
import '../data/about/team_text.dart';
import '../services/audio_service.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../providers/quiz_provider.dart';

class NavigationUtils {
  /// Call after [QuizProvider.resetQuiz] (or before deferred reset) when leaving
  /// the standard quiz [ResultScreen] stack. Daily challenge is opened from
  /// [AppRoutes.main]; a bare [pop] can leave an invalid stack or return to
  /// [AppRoutes.quiz] still marked finished, which immediately opens result again.
  static void leaveStandardQuizRoute(BuildContext context, QuizProvider provider) {
    if (provider.currentCategory == 'daily_challenge') {
      context.go(AppRoutes.main);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.main);
    }
  }

  static Widget buildProfileMenu(
    BuildContext context, {
    Color color = Colors.white,
  }) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: color),
      tooltip: 'Options',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'profile') {
          context.go(AppRoutes.profiles);
        } else if (value == 'sound') {
          // Toggle sound
          context.read<AudioService>().toggleMute();
        } else if (value == 'achievements') {
          context.push(AppRoutes.achievements);
        } else if (value == 'acknowledgements') {
          _showAcknowledgementsDialog(context);
        } else if (value == 'about') {
          _showAboutDialog(context);
        } else if (value == 'feedback') {
          _showFeedbackDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        final audioService = context.read<AudioService>();
        final isMuted = audioService.isMuted;

        return [
          PopupMenuItem<String>(
            value: 'sound',
            child: Row(
              children: [
                Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(isMuted ? 'Turn Sound On' : 'Turn Sound Off'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'achievements',
            child: Row(
              children: [
                Icon(Icons.menu_book, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Achievements Book'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'about',
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.primary),
                SizedBox(width: 12),
                Text('About'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'feedback',
            child: Row(
              children: [
                Icon(Icons.feedback_outlined, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Feedback & Support'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'acknowledgements',
            child: Row(
              children: [
                Icon(Icons.favorite_border_rounded, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Acknowledgements'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.people_outline, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Back to Profiles'),
              ],
            ),
          ),
        ];
      },
    );
  }

  static void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 520,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 8, 16),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'About Bird Whizz',
                        style: AppTextStyles.dialogTitle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ackSection(
                        icon: Icons.flutter_dash,
                        title: 'The App',
                        children: const [
                          _AboutParagraph(aboutAppText),
                        ],
                      ),
                      _ackSection(
                        icon: Icons.people_outline,
                        title: 'The Team',
                        children: const [
                          _AboutParagraph(aboutTeamText),
                        ],
                      ),
                      _ackSection(
                        icon: Icons.lightbulb_outline_rounded,
                        title: 'Our Mission',
                        children: const [
                          _AboutParagraph(aboutMissionText),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 520,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 8, 16),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.feedback_outlined, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Feedback & Support',
                        style: AppTextStyles.dialogTitle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ackSection(
                        icon: Icons.email_outlined,
                        title: 'Get In Touch',
                        children: const [
                          _AboutParagraph(feedbackText),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showAcknowledgementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 520,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 8, 16),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volunteer_activism, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Acknowledgements',
                        style: AppTextStyles.dialogTitle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ackSection(
                        icon: Icons.camera_alt_outlined,
                        title: 'Content Credits',
                        children: const [
                          _AckRow(label: 'Photography & Questions', value: 'Ivy Waring'),
                          _AckRow(label: 'Bird Photos Dataset', value: 'Nuthatch API'),
                        ],
                      ),
                      _ackSection(
                        icon: Icons.music_note_rounded,
                        title: 'Sound Effects',
                        children: const [
                          _AckRow(label: 'UI Tap', value: 'subquire · CC0'),
                          _AckRow(label: 'Woosh Transition', value: 'florianreichelt · CC0'),
                          _AckRow(label: 'Page Turn', value: 'SpaceJoe · CC0'),
                          _AckRow(label: 'Pop UI', value: 'Marevnik · CC BY 4.0'),
                          _AckRow(label: 'Key Tap', value: 'SDLx · CC BY 3.0'),
                          _AckRow(label: 'Thud', value: 'farbin · Sampling+'),
                          _AckRow(label: 'Correct Bell', value: 'Fupicat · CC0'),
                          _AckRow(label: 'Wrong Answer', value: 'BeetleMuse · CC0'),
                          _AckRow(label: 'Quiz Complete', value: 'Justvic · CC0'),
                          _AckRow(label: 'Intro / Birdsong', value: 'newlocknew · CC BY 4.0'),
                          _AckRow(label: 'Level Up Jingle', value: 'Sirkoto51 · CC BY 4.0'),
                        ],
                      ),
                      _ackSection(
                        icon: Icons.forest_rounded,
                        title: 'Background Music',
                        children: const [
                          _AckRow(label: 'Birds In The Forest', value: 'Arsen2005 · CC BY 4.0'),
                          _AckRow(label: 'Mixed Forest (Spring)', value: 'Garuda1982 · CC BY 4.0'),
                          _AckRow(label: 'Forest & Pond Birds', value: 'dibko · CC BY 4.0'),
                          _AckRow(label: 'Forest Birds', value: 'AbsynthFactory · CC0'),
                        ],
                      ),
                      _ackSection(
                        icon: Icons.photo_library_outlined,
                        title: 'Photo Credits (Unsplash)',
                        children: const [
                          _AckRow(label: 'Orange-chinned Parakeet', value: 'Zdeněk Macháček'),
                          _AckRow(label: 'Kingfisher', value: 'Boris Smokrovic'),
                          _AckRow(label: 'Keel-billed Toucan', value: 'Zdeněk Macháček'),
                          _AckRow(label: 'Indian White-eye', value: 'Boris Smokrovic'),
                          _AckRow(label: 'American Flamingo', value: 'Alejandro Contreras'),
                          _AckRow(label: 'Northern Cardinal', value: 'Timothy Dykes'),
                          _AckRow(label: 'Blue & Yellow Macaw', value: 'Andrew Pons'),
                          _AckRow(label: 'Yellow-throated Macaw', value: 'Zdeněk Macháček'),
                          _AckRow(label: 'Blue Macaw', value: 'Dominik Lange'),
                          _AckRow(label: 'Atlantic Puffin', value: 'Ray Hennessy'),
                          _AckRow(label: 'Laughing Gull', value: 'Brian Asare'),
                          _AckRow(label: 'Blue-tailed Bee-eater', value: 'SK Yeong'),
                          _AckRow(label: 'Short-eared Owl', value: 'Richard Lee'),
                          _AckRow(label: 'American Yellow Warbler', value: 'Mark Olsen'),
                          _AckRow(label: 'Bald Eagle', value: 'Philipp Pilz'),
                          _AckRow(label: 'Rufous Hummingbird', value: 'Bryan Hanson'),
                          _AckRow(label: 'White-necked Jacobin', value: 'Zdeněk Macháček'),
                          _AckRow(label: 'Lilac-breasted Roller', value: 'David Clode'),
                          _AckRow(label: 'Western Bluebird', value: 'Benoit Gauzere'),
                          _AckRow(label: 'Greater Racket-tailed Drongo', value: 'Trison Thomas'),
                          _AckRow(label: 'Frigatebird', value: 'Chris Sabor'),
                          _AckRow(label: 'Emerald Hummingbird', value: 'AARN GIRI'),
                          _AckRow(label: 'Tufted Titmouse', value: 'Mark Olsen'),
                          _AckRow(label: 'American Goldfinch', value: 'Joshua J. Cotten'),
                          _AckRow(label: 'Indian Peacock', value: 'ricardo frantz'),
                          _AckRow(label: 'Canada Geese', value: 'Gary Bendig'),
                          _AckRow(label: 'Yellow Indian Ringnecked Parakeet', value: 'David Clode'),
                          _AckRow(label: 'Little Egret', value: 'Pete Guan'),
                          _AckRow(label: 'Great Horned Owl', value: 'Sonder Quest'),
                          _AckRow(label: 'Mountain Bluebird', value: 'John Duncan'),
                          _AckRow(label: 'Little Owl', value: 'Zdeněk Macháček'),
                          _AckRow(label: 'Violetear Hummingbird', value: 'Chris Charles'),
                          _AckRow(label: 'Additional Photography', value: 'Ivy Waring'),
                        ],
                      ),
                      Center(
                        child: Text(
                          'Audio sourced from freesound.org',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _ackSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.sectionHeader,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.primary, width: 2)),
            ),
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildBackButton(
    BuildContext context, {
    Color color = Colors.white,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed ?? () => context.pop(),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: color,
      tooltip: 'Back',
    );
  }
}

class _AboutParagraph extends StatelessWidget {
  final String text;

  const _AboutParagraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        style: AppTextStyles.bodyCaption,
      ),
    );
  }
}

class _AckRow extends StatelessWidget {
  final String label;
  final String value;

  const _AckRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/user_profile.dart';
import '../models/bird.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AudioService>().playMenuMusic();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDeep,
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF80CBC4),
              AppColors.primaryLight,
            ],
            stops: [0.0, 0.2, 0.5, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Consumer<QuizProvider>(
            builder: (context, provider, child) {
              final profiles = provider.profiles;

              return Column(
                children: [
                  _Header(controller: _controller),
                  Expanded(
                    child: profiles.isEmpty
                        ? _EmptyState(controller: _controller)
                        : _ProfileList(
                            profiles: profiles,
                            controller: _controller,
                            provider: provider,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AnimationController controller;

  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            children: [
              // Decorative bird silhouettes row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BirdSilhouette(size: 18, opacity: 0.4),
                  const SizedBox(width: 12),
                  _BirdSilhouette(size: 24, opacity: 0.6),
                  const SizedBox(width: 16),
                  _BirdSilhouette(size: 20, opacity: 0.5),
                  const SizedBox(width: 20),
                  _BirdSilhouette(size: 28, opacity: 0.7),
                  const SizedBox(width: 14),
                  _BirdSilhouette(size: 18, opacity: 0.4),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'BIRD WHIZZ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4.0,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose Your Adventurer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirdSilhouette extends StatelessWidget {
  final double size;
  final double opacity;

  const _BirdSilhouette({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Icon(
        Icons.flutter_dash,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

// ── Profile list ─────────────────────────────────────────────────────────────

class _ProfileList extends StatelessWidget {
  final List<UserProfile> profiles;
  final AnimationController controller;
  final QuizProvider provider;

  const _ProfileList({
    required this.profiles,
    required this.controller,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: profiles.length + 1,
          itemBuilder: (context, index) {
            if (index == profiles.length) {
              return _animatedItem(
                index: index,
                total: profiles.length + 1,
                child: _AddNewCard(),
              );
            }
            return _animatedItem(
              index: index,
              total: profiles.length + 1,
              child: _ProfileCard(
                profile: profiles[index],
                provider: provider,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _animatedItem({
    required int index,
    required int total,
    required Widget child,
  }) {
    final start = (index / (total + 1) * 0.6 + 0.15).clamp(0.0, 0.95);
    final end = (start + 0.35).clamp(0.0, 1.0);

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

// ── Profile card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final QuizProvider provider;

  const _ProfileCard({required this.profile, required this.provider});

  int get _totalStars {
    int total = 0;
    profile.levelStars.forEach((_, s) => total += s);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Bird? bird;
    try {
      bird = availableBirds.firstWhere((b) => b.id == profile.companionBirdId);
    } catch (_) {}

    final stars = _totalStars;
    final evoStage = provider.getEvolutionStageForStars(stars);
    final birdColor = bird?.color ?? AppColors.primary;
    final streak = profile.currentLoginStreak;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        elevation: 6,
        shadowColor: birdColor.withValues(alpha: 0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await provider.selectProfile(profile.id);
            if (context.mounted) context.go(AppRoutes.main);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Subtle bird-color wash on the right
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            birdColor.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Left accent strip
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          birdColor.withValues(alpha: 0.7),
                          birdColor,
                        ],
                      ),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 48, 14),
                  child: Row(
                    children: [
                      _BirdAvatar(
                        bird: bird,
                        evoStage: evoStage,
                        birdColor: birdColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                                height: 1.1,
                              ),
                            ),
                            if (bird != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                bird.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: birdColor.withValues(alpha: 0.85),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            _StatsRow(
                              stars: stars,
                              correct: profile.totalCorrectAnswers,
                              streak: streak,
                              birdColor: birdColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button top-right
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.grey[400],
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    onPressed: () => _showDeleteDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Profile?'),
        content: Text(
          'Are you sure you want to delete ${profile.name} and all their progress?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<QuizProvider>(context, listen: false)
                  .deleteProfile(profile.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _BirdAvatar extends StatelessWidget {
  final Bird? bird;
  final int evoStage;
  final Color birdColor;

  const _BirdAvatar({
    required this.bird,
    required this.evoStage,
    required this.birdColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: birdColor.withValues(alpha: 0.12),
            border: Border.all(color: birdColor.withValues(alpha: 0.6), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: birdColor.withValues(alpha: 0.25),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: bird != null
                ? Image.asset(
                    bird!.getEvolvedImagePath(evoStage),
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Text('?', style: TextStyle(fontSize: 32)),
                  ),
          ),
        ),
        // Evolution stage badge
        if (bird != null)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: birdColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: birdColor.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                _stageLabel(evoStage),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _stageLabel(int stage) {
    const labels = ['I', 'II', 'III', 'IV', 'V'];
    final i = (stage - 1).clamp(0, labels.length - 1);
    return 'Lv.${labels[i]}';
  }
}

class _StatsRow extends StatelessWidget {
  final int stars;
  final int correct;
  final int streak;
  final Color birdColor;

  const _StatsRow({
    required this.stars,
    required this.correct,
    required this.streak,
    required this.birdColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        _StatPill(
          icon: Icons.star_rounded,
          iconColor: AppColors.star,
          label: '$stars stars',
        ),
        _StatPill(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.success,
          label: '$correct correct',
        ),
        if (streak > 1)
          _StatPill(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.deepOrange,
            label: '$streak day streak',
          ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _StatPill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// ── Add New card ─────────────────────────────────────────────────────────────

class _AddNewCard extends StatelessWidget {
  const _AddNewCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push(AppRoutes.birdSelect),
          child: DashedBorder(
            borderRadius: 18,
            color: Colors.white.withValues(alpha: 0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New Adventurer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple dashed border container using CustomPaint.
class DashedBorder extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const DashedBorder({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = 12,
    this.strokeWidth = 1.8,
    this.dashLength = 8,
    this.gapLength = 5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashLength,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.borderRadius != borderRadius ||
      old.strokeWidth != strokeWidth;
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AnimationController controller;

  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    final scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: scale,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.flutter_dash,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No adventurers yet!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first profile to begin\nyour bird-watching journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.birdSelect),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

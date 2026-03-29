import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../models/question.dart';
import '../router/app_router.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/quiz_animations.dart';
import '../services/audio_service.dart';

class EndlessQuizScreen extends StatefulWidget {
  const EndlessQuizScreen({super.key});

  @override
  State<EndlessQuizScreen> createState() => _EndlessQuizScreenState();
}

class _EndlessQuizScreenState extends State<EndlessQuizScreen> {
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();
  int? _lastQuestionIndex;
  bool _pushedResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AudioService>().playQuizMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        // If the run has finished, jump to the Endless Result screen
        if (!_pushedResult &&
            !provider.isEndlessMode &&
            provider.lastEndlessStreak > 0) {
          _pushedResult = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.pushReplacement(AppRoutes.endlessResult);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final Question question = provider.endlessCurrentQuestion;

        // Trigger animations on answer
        if (provider.selectedAnswerIndex != null) {
          if (_lastQuestionIndex != provider.currentQuestionIndex) {
            _lastQuestionIndex = provider.currentQuestionIndex;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final audioService = context.read<AudioService>();
              if (provider.selectedAnswerIndex == question.correctOptionIndex) {
                _confettiKey.currentState?.burst();
                audioService.playCorrectSound();
              } else {
                final key = GlobalObjectKey<ShakeWidgetState>(
                  provider.currentQuestionIndex,
                );
                key.currentState?.shake();
                audioService.playWrongSound();
              }
            });
          }
        }

        return ConfettiOverlay(
          key: _confettiKey,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF26A69A), Color(0xFF004D40)],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Column(
                  children: [
                    const Text(
                      'ENDLESS MODE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white70,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orangeAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Streak: ${provider.endlessStreak}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${3 - provider.endlessStrikes}/3',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  NavigationUtils.buildProfileMenu(
                    context,
                    color: Colors.white,
                  ),
                ],
              ),
              body: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          final inAnimation = Tween<Offset>(
                            begin: const Offset(1.2, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          final outAnimation = Tween<Offset>(
                            begin: const Offset(-1.2, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          if (child.key ==
                              ValueKey(provider.currentQuestionIndex)) {
                            return SlideTransition(
                              position: inAnimation,
                              child: child,
                            );
                          } else {
                            return SlideTransition(
                              position: outAnimation,
                              child: child,
                            );
                          }
                        },
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ...previousChildren,
                              ?currentChild,
                            ],
                          );
                        },
                        child: Column(
                          key: ValueKey(provider.currentQuestionIndex),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (question.imagePath != null) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          question.imagePath!,
                                          height: 180,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (ctx, error, stackTrace) =>
                                                  const SizedBox(
                                                    height: 50,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                    Consumer<AudioService>(
                                      builder: (context, audioService, _) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 40.0,
                                                  ),
                                              child: Text(
                                                question.text,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF2C3E50,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              top: 0,
                                              child: Center(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.volume_up_rounded,
                                                    color: Colors.teal,
                                                  ),
                                                  onPressed: () {
                                                    final sequence = [
                                                      question
                                                          .questionAudioPath,
                                                      for (
                                                        int i = 0;
                                                        i <
                                                            question
                                                                .options
                                                                .length;
                                                        i++
                                                      )
                                                        question
                                                            .getAnswerAudioPath(
                                                              i,
                                                            ),
                                                    ];
                                                    audioService.playSequence(
                                                      sequence,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              flex: 5,
                              child: ShakeWidget(
                                key: GlobalObjectKey<ShakeWidgetState>(
                                  provider.currentQuestionIndex,
                                ),
                                child: Column(
                                  children: List.generate(
                                    question.options.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: _buildOptionButton(
                                          context,
                                          provider,
                                          index,
                                          question,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    QuizProvider provider,
    int index,
    Question question,
  ) {
    Color backgroundColor = Colors.white.withValues(alpha: 0.95);
    Color borderColor = Colors.transparent;
    Color textColor = Colors.black87;
    double elevation = 2;

    if (provider.selectedAnswerIndex != null) {
      if (index == provider.selectedAnswerIndex) {
        if (index == question.correctOptionIndex) {
          backgroundColor = Colors.green.shade100;
          borderColor = Colors.green;
          textColor = Colors.green.shade900;
        } else {
          backgroundColor = Colors.red.shade100;
          borderColor = Colors.red;
          textColor = Colors.red.shade900;
        }
      } else if (index == question.correctOptionIndex) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        textColor = Colors.green.shade900;
        elevation = 0;
      } else {
        backgroundColor = Colors.white.withValues(alpha: 0.5);
        textColor = Colors.grey.shade600;
        elevation = 0;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () => provider.selectAnswer(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                question.options[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: -8,
              child: Consumer<AudioService>(
                builder: (context, audioService, _) {
                  return IconButton(
                    icon: Icon(
                      Icons.volume_up_rounded,
                      color: textColor.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onPressed: () {
                      audioService.playVoiceOver(
                        question.getAnswerAudioPath(index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

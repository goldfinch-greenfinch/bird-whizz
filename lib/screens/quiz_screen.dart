import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/question.dart';
import 'result_screen.dart';
import 'level_up_screen.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/quiz_animations.dart';
import '../services/audio_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();
  // Removed _shakeKey to avoid duplicate keys during transitions

  // Track previous state to trigger animations only once per question/answer
  int? _lastSelectedQuestionIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        // Handle Quiz Completion
        if (provider.isQuizFinished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.hasLeveledUp) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LevelUpScreen(
                    oldRank: provider.oldLevelTitle ?? 'Unknown',
                    newRank: provider.newLevelTitle ?? 'Bird Wizard',
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ResultScreen()),
              );
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = provider.currentQuestion;
        final categoryTheme = _getCategoryTheme(provider.currentCategory);

        // Check for answer selection to trigger animations
        if (provider.selectedAnswerIndex != null) {
          if (_lastSelectedQuestionIndex != provider.currentQuestionIndex) {
            _lastSelectedQuestionIndex = provider.currentQuestionIndex;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final audioService = context.read<AudioService>();
              if (provider.selectedAnswerIndex == question.correctOptionIndex) {
                _confettiKey.currentState?.burst();
                audioService.playCorrectSound();
              } else {
                // Use a unique key based on index to find the correct widget to shake
                final key = GlobalObjectKey<ShakeWidgetState>(
                  provider.currentQuestionIndex,
                );
                key.currentState?.shake();
                audioService.playWrongSound();
              }
            });
          }
        } else {
          // Reset tracker if needed, though mostly handled by index check
        }

        return ConfettiOverlay(
          key: _confettiKey,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: categoryTheme,
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
                    Text(
                      provider.currentCategory.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${provider.currentLevel?.name ?? 'Quiz'} - Q${provider.currentQuestionIndex + 1}/${provider.totalQuestions}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    child: Column(
                      key: ValueKey(provider.currentQuestionIndex),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Question Card
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
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
                                      errorBuilder: (ctx, error, stackTrace) =>
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
                                          padding: const EdgeInsets.symmetric(
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
                                                  fontWeight: FontWeight.w600,
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
                                                  question.questionAudioPath,
                                                  for (
                                                    int i = 0;
                                                    i < question.options.length;
                                                    i++
                                                  )
                                                    question.getAnswerAudioPath(
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

                        // Options
                        Expanded(
                          flex: 5,
                          child: ShakeWidget(
                            key: GlobalObjectKey<ShakeWidgetState>(
                              provider.currentQuestionIndex,
                            ),
                            child: Column(
                              children: List.generate(question.options.length, (
                                index,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: _buildOptionButton(
                                    context,
                                    provider,
                                    index,
                                    question,
                                  ),
                                );
                              }),
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
        elevation = 0; // Flatten others
      } else {
        backgroundColor = Colors.white.withValues(
          alpha: 0.5,
        ); // Dediphasize others
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

  List<Color> _getCategoryTheme(String category) {
    switch (category.toLowerCase()) {
      case 'trivia':
        return [Colors.teal.shade400, Colors.teal.shade800];
      case 'biology':
        return [Colors.tealAccent.shade700, Colors.teal.shade700];
      case 'habitat':
        return [Colors.teal.shade700, Colors.teal.shade900];
      case 'conservation':
        return [Colors.green.shade500, Colors.teal.shade600];
      case 'behaviour':
        return [Colors.teal.shade300, Colors.cyan.shade200];
      case 'families':
        return [Colors.teal.shade900, Colors.blueGrey.shade700];
      case 'migration':
        return [Colors.cyan.shade300, Colors.blue.shade400];
      case 'colours':
        return [Colors.cyan.shade600, Colors.teal.shade500];
      default:
        return [Colors.teal.shade400, Colors.teal.shade800];
    }
  }
}

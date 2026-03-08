import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/bird.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/navigation_utils.dart';
import 'package:confetti/confetti.dart';

class UnscrambleGameScreen extends StatefulWidget {
  final int minLength;
  final int maxLength;
  final String title;

  const UnscrambleGameScreen({
    super.key,
    required this.minLength,
    required this.maxLength,
    required this.title,
  });

  @override
  State<UnscrambleGameScreen> createState() => _UnscrambleGameScreenState();
}

class _UnscrambleGameScreenState extends State<UnscrambleGameScreen> {
  late ConfettiController _confettiController;
  Bird? _currentBird;
  List<String> _targetLetters = [];
  List<String?> _scrambledLetters = [];
  List<String?> _userArrangement = [];
  int _score = 0;
  int _questionsAnswered = 0;
  bool _isSuccess = false;
  List<Bird> _birdQueue = [];

  int _totalQuestions = 10;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    List<Bird> filtered = availableBirds.where((b) {
      String w = b.name.toUpperCase().replaceAll(' ', '').replaceAll('-', '');
      return w.length >= widget.minLength && w.length <= widget.maxLength;
    }).toList();

    if (filtered.isEmpty) {
      filtered = List.from(availableBirds);
    }

    filtered.shuffle();
    int needed = 10;
    if (filtered.length < needed) {
      needed = filtered.length;
    }
    _totalQuestions = needed;
    _birdQueue = filtered.sublist(0, needed);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
    });
    _startNewRound();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startNewRound() {
    if (_questionsAnswered >= _totalQuestions) {
      _navigateToResultScreen();
      return;
    }

    setState(() {
      _isSuccess = false;

      _currentBird = _birdQueue.removeLast();

      String word = _currentBird!.name
          .toUpperCase()
          .replaceAll(' ', '')
          .replaceAll('-', '');

      _targetLetters = word.split('');
      _scrambledLetters = List<String?>.from(_targetLetters)..shuffle();
      _userArrangement = List.filled(_targetLetters.length, null);
    });
  }

  void _navigateToResultScreen() {
    final provider = context.read<QuizProvider>();
    provider.saveWordGameStars(
      widget.title,
      _score,
      totalQuestions: _totalQuestions,
    );

    context.pushReplacement(AppRoutes.result);
  }

  void _onLetterTapped(String letter) {
    if (_isSuccess) return;
    context.read<AudioService>().playLetterTap();

    setState(() {
      int emptyIndex = _userArrangement.indexOf(null);
      if (emptyIndex != -1) {
        _userArrangement[emptyIndex] = letter;
        _removeLetterFromPool(letter);
      }
      _checkWinCondition();
    });
  }

  void _removeLetterFromPool(String letter) {
    // Remove the *first* instance of this letter from the scrambled pool
    final letterIndex = _scrambledLetters.indexOf(letter);
    if (letterIndex != -1) {
      _scrambledLetters[letterIndex] = null;
    }
  }

  void _returnLetterToPool(int index) {
    if (_isSuccess) return;

    final letter = _userArrangement[index];
    if (letter != null) {
      context.read<AudioService>().playLetterTap();
      setState(() {
        _userArrangement[index] = null;
        final emptyIndex = _scrambledLetters.indexOf(null);
        if (emptyIndex != -1) {
          _scrambledLetters[emptyIndex] = letter;
        } else {
          _scrambledLetters.add(letter);
        }
      });
    }
  }

  void _checkWinCondition() {
    // maximize simple logic: join user arrangement, compare to target
    String currentWord = _userArrangement.join('');
    String targetWord = _targetLetters.join('');

    if (currentWord == targetWord) {
      _isSuccess = true;
      _score++;
      _questionsAnswered++;
      _confettiController.play();
      context.read<AudioService>().playCorrectSound();

      // Update High Score and Total Word count
      context.read<QuizProvider>().updateUnscrambleHighScore(_score);
      context.read<QuizProvider>().incrementUnscrambledWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBird == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hint Section
                        SizedBox(
                          height: (MediaQuery.of(context).size.height * 0.28)
                              .clamp(180.0, 280.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Image.asset(
                              _currentBird!.imagePath,
                              key: ValueKey('$_isSuccess-${_currentBird!.id}'),
                              color: _isSuccess ? null : Colors.black,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withValues(alpha: 0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            _currentBird!.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.teal.shade800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Drop Zones
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_targetLetters.length, (
                                index,
                              ) {
                                final letter = _userArrangement[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _returnLetterToPool(index),
                                    child: Container(
                                      width: 45,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: letter != null
                                            ? Colors.deepPurpleAccent
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _isSuccess
                                              ? Colors.green
                                              : Colors.deepPurpleAccent,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          letter ?? '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Scrambled Letters Pool
                        if (!_isSuccess)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: _scrambledLetters.map((letter) {
                              if (letter == null) {
                              final tileSize = (MediaQuery.of(context).size.width * 0.13).clamp(44.0, 70.0);
                              return SizedBox(width: tileSize, height: tileSize * 1.2);
                            }
                              return GestureDetector(
                                onTap: () => _onLetterTapped(letter),
                                child: _buildLetterTile(letter),
                              );
                            }).toList(),
                          )
                        else
                          Column(
                            children: [
                              const Text(
                                'Correct!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _startNewRound,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text(
                                  'Next Bird',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterTile(
    String letter, {
    bool isFeedback = false,
    bool isGhost = false,
  }) {
    final tileSize = (MediaQuery.of(context).size.width * 0.13).clamp(44.0, 70.0);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: tileSize,
        height: tileSize * 1.2,
        decoration: BoxDecoration(
          color: isGhost
              ? Colors.grey.withValues(alpha: 0.3)
              : Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isGhost ? Colors.transparent : Colors.deepPurpleAccent,
            width: 2,
          ),
          boxShadow: isGhost || isFeedback
              ? []
              : [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isGhost ? Colors.transparent : Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationUtils.buildBackButton(context, color: Colors.black87),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  'Word ${_questionsAnswered < _totalQuestions && !_isSuccess ? _questionsAnswered + 1 : _questionsAnswered} of $_totalQuestions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// removed _ReturnToMenuPlaceholder

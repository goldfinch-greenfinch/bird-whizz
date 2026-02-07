import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bird.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import '../widgets/navigation_utils.dart';
import 'package:confetti/confetti.dart';

class UnscrambleGameScreen extends StatefulWidget {
  const UnscrambleGameScreen({super.key});

  @override
  State<UnscrambleGameScreen> createState() => _UnscrambleGameScreenState();
}

class _UnscrambleGameScreenState extends State<UnscrambleGameScreen> {
  late ConfettiController _confettiController;
  Bird? _currentBird;
  List<String> _targetLetters = [];
  List<String> _scrambledLetters = [];
  List<String?> _userArrangement = [];
  int _score = 0;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _startNewRound();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startNewRound() {
    setState(() {
      _isSuccess = false;
      // Pick a random bird
      _currentBird = availableBirds[Random().nextInt(availableBirds.length)];

      // Prepare word (uppercase, remove spaces/hyphens for simplicity if needed, but let's keep them tricky?)
      // For simplicity, let's use the Name, not ID, as ID might be simple like 'penguin' but name 'Puddles'.
      // Wait, the requirement said "Bird Name (e.g. NIGNEPU -> PENGUIN)".
      // Let's use `bird.id` or `bird.name`?
      // User request: "Show a scrambled bird name (e.g., "NIGNEPU") ... bird.id seems more appropriate for species name usually, but here ID is 'penguin', Name is 'Puddles'.
      // Let's use the ID (Species) as it's more educational for "Bird Word Games".
      String word = _currentBird!.id.toUpperCase();

      _targetLetters = word.split('');
      _scrambledLetters = List.from(_targetLetters)..shuffle();
      _userArrangement = List.filled(_targetLetters.length, null);
    });
  }

  void _onLetterDropped(String letter, int index) {
    if (_isSuccess) return;

    setState(() {
      // If slot is empty, fill it
      if (_userArrangement[index] == null) {
        _userArrangement[index] = letter;
        _removeLetterFromPool(letter);
      } else {
        // Swap? Or return existing to pool?
        // For simplicity: return existing to pool, place new one
        String existing = _userArrangement[index]!;
        _scrambledLetters.add(existing);
        _userArrangement[index] = letter;
        _removeLetterFromPool(letter);
      }

      _checkWinCondition();
    });
  }

  void _removeLetterFromPool(String letter) {
    // Remove the *first* instance of this letter from the scrambled pool
    final letterIndex = _scrambledLetters.indexOf(letter);
    if (letterIndex != -1) {
      _scrambledLetters.removeAt(letterIndex);
    }
  }

  void _returnLetterToPool(int index) {
    if (_isSuccess) return;

    final letter = _userArrangement[index];
    if (letter != null) {
      setState(() {
        _userArrangement[index] = null;
        _scrambledLetters.add(letter);
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
      _confettiController.play();
      context.read<AudioService>().playCorrectSound();

      // Update High Score
      context.read<QuizProvider>().updateUnscrambleHighScore(_score);
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
                        Text(
                          _currentBird!.emoji,
                          style: const TextStyle(fontSize: 80),
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
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_targetLetters.length, (
                            index,
                          ) {
                            return DragTarget<String>(
                              onAcceptWithDetails: (details) =>
                                  _onLetterDropped(details.data, index),
                              builder: (context, candidateData, rejectedData) {
                                final letter = _userArrangement[index];
                                final isCandidate = candidateData.isNotEmpty;

                                return GestureDetector(
                                  onTap: () => _returnLetterToPool(index),
                                  child: Container(
                                    width: 45,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: letter != null
                                          ? Colors.deepPurpleAccent
                                          : (isCandidate
                                                ? Colors.deepPurple.shade100
                                                : Colors.white),
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
                                );
                              },
                            );
                          }),
                        ),

                        const Spacer(),

                        // Scrambled Letters Pool
                        if (!_isSuccess)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: _scrambledLetters.map((letter) {
                              return Draggable<String>(
                                data: letter,
                                feedback: _buildLetterTile(
                                  letter,
                                  isFeedback: true,
                                ),
                                childWhenDragging: _buildLetterTile(
                                  letter,
                                  isGhost: true,
                                ),
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
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 50,
        height: 60,
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
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/guess_bird_data.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/common_profile_header.dart';
import '../widgets/quiz_animations.dart';

class GuessBirdScreen extends StatefulWidget {
  final int levelIndex;

  const GuessBirdScreen({super.key, required this.levelIndex});

  @override
  State<GuessBirdScreen> createState() => _GuessBirdScreenState();
}

class _GuessBirdScreenState extends State<GuessBirdScreen>
    with TickerProviderStateMixin {
  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _photoRevealController;
  late Animation<double> _photoRevealAnimation;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  GuessBirdLevel get _level => guessBirdLevels[widget.levelIndex];
  GuessBirdQuestion get _currentQuestion =>
      _level.questions[_questionIndex];

  bool get _isLastQuestion =>
      _questionIndex >= _level.questions.length - 1;

  bool get _showRevealButton => !_isAnswered && _wrongAttempts >= 2;

  String get _hint {
    // Show first letter of each word, rest as underscores
    return _currentQuestion.birdName
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0] + ('_' * (word.length - 1));
        })
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _photoRevealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _photoRevealAnimation = CurvedAnimation(
      parent: _photoRevealController,
      curve: Curves.easeOut,
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-0.03, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(-0.03, 0),
          end: const Offset(0.03, 0),
        ),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.03, 0), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(_shakeController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _photoRevealController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool _isCorrectAnswer(String input) {
    String normalize(String s) =>
        s.trim().toLowerCase().replaceAll('-', ' ').replaceAll(RegExp(r'\s+'), ' ');

    final normalizedInput = normalize(input);
    final normalizedCorrect = normalize(_currentQuestion.birdName);

    if (normalizedInput == normalizedCorrect) return true;
    for (final alias in _currentQuestion.aliases) {
      if (normalizedInput == normalize(alias)) return true;
    }
    return false;
  }

  void _submit() {
    if (_isAnswered || _controller.text.trim().isEmpty) return;

    if (_isCorrectAnswer(_controller.text)) {
      setState(() {
        _isAnswered = true;
        _isCorrect = true;
        _score++;
      });
      _photoRevealController.forward();
      _confettiKey.currentState?.burst();
      context.read<AudioService>().playCorrectSound();
      HapticFeedback.lightImpact();
    } else {
      setState(() => _wrongAttempts++);
      _shakeController.reset();
      _shakeController.forward();
      context.read<AudioService>().playWrongSound();
      HapticFeedback.mediumImpact();
    }
  }

  void _reveal() {
    setState(() {
      _isAnswered = true;
      _isCorrect = false;
    });
    _photoRevealController.forward();
    context.read<AudioService>().playWrongSound();
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _finishLevel();
      return;
    }
    setState(() {
      _questionIndex++;
      _isAnswered = false;
      _isCorrect = false;
      _wrongAttempts = 0;
      _controller.clear();
    });
    _photoRevealController.reset();
    _focusNode.requestFocus();
  }

  void _finishLevel() {
    final provider = context.read<QuizProvider>();
    provider.finishGuessBirdLevel(
      widget.levelIndex,
      _score,
      _level.questions.length,
    );
    context.read<AudioService>().playMenuMusic();
    context.pushReplacement(AppRoutes.result);
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      key: _confettiKey,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProgressBar(),
                      const SizedBox(height: 16),
                      _buildQuestionCard(),
                      const SizedBox(height: 16),
                      if (_isAnswered)
                        _buildResultCard()
                      else
                        _buildInputArea(),
                      const SizedBox(height: 24),
                      if (_isAnswered) _buildNextButton(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.indigo[700],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const CommonProfileHeader(),
    );
  }

  Widget _buildProgressBar() {
    final total = _level.questions.length;
    final completed = _questionIndex + (_isAnswered ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_questionIndex + 1} / $total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[800],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_score correct',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: completed / total,
            minHeight: 8,
            backgroundColor: Colors.indigo[100],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Description section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _level.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[700],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Icon(
                  Icons.help_outline_rounded,
                  size: 32,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 10),
                Text(
                  _currentQuestion.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),

          // Photo reveal (animated)
          AnimatedBuilder(
            animation: _photoRevealAnimation,
            builder: (context, child) {
              if (_photoRevealAnimation.value == 0) return const SizedBox.shrink();
              return Opacity(
                opacity: _photoRevealAnimation.value,
                child: Transform.scale(
                  scale: 0.85 + 0.15 * _photoRevealAnimation.value,
                  child: child,
                ),
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                _currentQuestion.imagePath,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, _) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hint display
        if (_wrongAttempts >= 1) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hint: $_hint',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[900],
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Text field with shake animation
        SlideTransition(
          position: _shakeAnimation,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Type the bird name…',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.indigo),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.indigo, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 12),

        // Buttons row
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),
            if (_showRevealButton) ...[
              const SizedBox(width: 10),
              TextButton(
                onPressed: _reveal,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Reveal',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final color = _isCorrect ? Colors.green : Colors.red[700]!;
    final icon = _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final label = _isCorrect
        ? '✓  Correct! Well done!'
        : 'The answer was: ${_currentQuestion.birdName}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        child: Text(
          _isLastQuestion ? 'Finish Level' : 'Next Bird →',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

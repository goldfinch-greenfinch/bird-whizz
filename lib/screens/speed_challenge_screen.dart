import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/speed_challenge_data.dart';
import '../providers/quiz_provider.dart';
import '../router/app_router.dart';
import '../services/audio_service.dart';
import '../widgets/common_profile_header.dart';
import '../widgets/quiz_animations.dart';

class SpeedChallengeScreen extends StatefulWidget {
  final int levelIndex;

  const SpeedChallengeScreen({super.key, required this.levelIndex});

  @override
  State<SpeedChallengeScreen> createState() => _SpeedChallengeScreenState();
}

class _SpeedChallengeScreenState extends State<SpeedChallengeScreen>
    with TickerProviderStateMixin {
  int _questionIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _isAnswered = false;
  bool _timedOut = false;

  late double _timeLeft;
  Timer? _countdownTimer;

  late AnimationController _timerRingController;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  SpeedChallengeLevel get _level => speedChallengeLevels[widget.levelIndex];
  SpeedChallengeQuestion get _currentQuestion =>
      _level.questions[_questionIndex];

  // Theme colour for this game mode
  static const Color _accent = Color(0xFFE65100); // deep orange
  static const Color _bg = Color(0xFFFFF3E0); // orange tint bg

  @override
  void initState() {
    super.initState();

    _timerRingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _level.secondsPerQuestion),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackAnimation = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
      _startQuestion();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _timerRingController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _startQuestion() {
    _timeLeft = _level.secondsPerQuestion.toDouble();
    _timerRingController.duration =
        Duration(seconds: _level.secondsPerQuestion);
    _timerRingController.forward(from: 0);

    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _timeLeft -= 0.1;
        if (_timeLeft <= 0) {
          _timeLeft = 0;
          t.cancel();
          _onTimeout();
        }
      });
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _timerRingController.stop();
  }

  void _onTimeout() {
    if (_isAnswered) return;
    HapticFeedback.mediumImpact();
    context.read<AudioService>().playWrongSound();
    setState(() {
      _isAnswered = true;
      _timedOut = true;
    });
    _feedbackController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1400), _advance);
  }

  void _onAnswer(int index) {
    if (_isAnswered) return;
    _stopTimer();

    final correct = index == _currentQuestion.correctIndex;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
      _timedOut = false;
      if (correct) _score++;
    });

    _feedbackController.forward(from: 0);

    if (correct) {
      HapticFeedback.lightImpact();
      context.read<AudioService>().playCorrectSound();
      _confettiKey.currentState?.burst();
    } else {
      HapticFeedback.mediumImpact();
      context.read<AudioService>().playWrongSound();
    }

    Future.delayed(const Duration(milliseconds: 1200), _advance);
  }

  void _advance() {
    if (!mounted) return;
    if (_questionIndex >= _level.questions.length - 1) {
      _finishLevel();
      return;
    }
    setState(() {
      _questionIndex++;
      _selectedIndex = null;
      _isAnswered = false;
      _timedOut = false;
    });
    _feedbackController.reset();
    _startQuestion();
  }

  void _finishLevel() {
    final provider = context.read<QuizProvider>();
    provider.finishSpeedChallengeLevel(
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
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProgressRow(),
                      const SizedBox(height: 16),
                      _buildTimerAndQuestion(),
                      const SizedBox(height: 16),
                      _buildAnswerOptions(),
                      const SizedBox(height: 12),
                      if (_isAnswered) _buildFeedbackBanner(),
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

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const CommonProfileHeader(),
    );
  }

  // ─── Progress row ────────────────────────────────────────────────────────────

  Widget _buildProgressRow() {
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
                color: _accent,
              ),
            ),
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green[600], size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_score correct',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
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
            minHeight: 7,
            backgroundColor: Colors.orange[100],
            valueColor: AlwaysStoppedAnimation<Color>(_accent),
          ),
        ),
      ],
    );
  }

  // ─── Timer ring + question ───────────────────────────────────────────────────

  Widget _buildTimerAndQuestion() {
    final secs = _level.secondsPerQuestion;
    final frac = _timeLeft / secs;
    final isLow = _timeLeft <= secs * 0.3;

    Color ringColor = isLow ? Colors.red[600]! : _accent;

    return Column(
      children: [
        // Timer ring — scales with screen width
        LayoutBuilder(
          builder: (context, constraints) {
            final ringSize = (MediaQuery.of(context).size.width * 0.22)
                .clamp(72.0, 120.0);
            final fontSize = ringSize * 0.34;
            return SizedBox(
              width: ringSize,
              height: ringSize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: frac.clamp(0.0, 1.0),
                    strokeWidth: ringSize * 0.09,
                    backgroundColor: Colors.orange[100],
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                  Center(
                    child: Text(
                      _timeLeft <= 0 ? '0' : _timeLeft.ceil().toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: isLow ? Colors.red[700] : _accent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildQuestionCard(),
      ],
    );
  }

  // ─── Question card ───────────────────────────────────────────────────────────

  Widget _buildQuestionCard() {
    final q = _currentQuestion;
    final isImage = q.type == SpeedQuestionType.image;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: _accent.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(
                  isImage ? Icons.image_rounded : Icons.quiz_rounded,
                  size: 18,
                  color: _accent,
                ),
                const SizedBox(width: 8),
                Text(
                  isImage ? 'Identify the Bird' : 'Bird Knowledge',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _accent,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _level.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _accent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isImage) ...[
            // Bird photo
            Image.asset(
              q.imagePath!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, _) => Container(
                height: 120,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Which bird is this?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ] else ...[
            // Text question
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                q.questionText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Answer buttons ──────────────────────────────────────────────────────────

  Widget _buildAnswerOptions() {
    return Column(
      children: List.generate(
        _currentQuestion.options.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildOptionButton(i),
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    final correct = _currentQuestion.correctIndex;
    final label = _currentQuestion.options[index];

    Color bg = Colors.white;
    Color border = _accent.withValues(alpha: 0.3);
    Color text = Colors.black87;
    Widget? trailingIcon;

    if (_isAnswered) {
      if (index == correct) {
        bg = Colors.green[50]!;
        border = Colors.green;
        text = Colors.green[800]!;
        trailingIcon = const Icon(Icons.check_circle_rounded, color: Colors.green);
      } else if (index == _selectedIndex && _selectedIndex != correct) {
        bg = Colors.red[50]!;
        border = Colors.red[400]!;
        text = Colors.red[800]!;
        trailingIcon = Icon(Icons.cancel_rounded, color: Colors.red[400]);
      } else {
        bg = Colors.grey[50]!;
        border = Colors.grey[200]!;
        text = Colors.grey[500]!;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.5),
        boxShadow: _isAnswered
            ? null
            : [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: InkWell(
        onTap: _isAnswered ? null : () => _onAnswer(index),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Option letter badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _isAnswered
                      ? border.withValues(alpha: 0.15)
                      : _accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _isAnswered ? text : _accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: text,
                  ),
                ),
              ),
              ?trailingIcon,
            ],
          ),
        ),
      ),
    );
  }

  // ─── Feedback banner ─────────────────────────────────────────────────────────

  Widget _buildFeedbackBanner() {
    final correct = _selectedIndex == _currentQuestion.correctIndex;
    final isTimeout = _timedOut;

    Color color;
    String message;
    IconData icon;

    if (isTimeout) {
      color = Colors.orange[700]!;
      message = 'Time\'s up! The answer was: ${_currentQuestion.options[_currentQuestion.correctIndex]}';
      icon = Icons.timer_off_rounded;
    } else if (correct) {
      color = Colors.green[700]!;
      message = 'Correct!';
      icon = Icons.check_circle_rounded;
    } else {
      color = Colors.red[700]!;
      message = 'Wrong! The answer was: ${_currentQuestion.options[_currentQuestion.correctIndex]}';
      icon = Icons.cancel_rounded;
    }

    return FadeTransition(
      opacity: _feedbackAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

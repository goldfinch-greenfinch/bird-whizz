import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/crossbird_data.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';
import '../widgets/navigation_utils.dart';
import 'result_screen.dart';

class CrossbirdScreen extends StatefulWidget {
  final int puzzleIndex;

  const CrossbirdScreen({super.key, required this.puzzleIndex});

  @override
  State<CrossbirdScreen> createState() => _CrossbirdScreenState();
}

class _CrossbirdScreenState extends State<CrossbirdScreen>
    with SingleTickerProviderStateMixin {
  late final CrossbirdPuzzle _puzzle;
  late final List<bool> _solved;
  late final Map<(int, int), String> _lockedLetters;
  late final ConfettiController _confetti;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final ScrollController _clueScrollController;

  int? _selectedWordIndex;
  // letters currently being typed (not yet confirmed)
  Map<(int, int), String> _draftLetters = {};
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isWrong = false;
  bool _allDone = false;

  // Cached grid info
  late final Map<(int, int), List<int>> _cellToWordIndices;
  // clueNumber+direction → word index (for display deduplication)
  late final Map<String, int> _clueKeyToIndex;

  @override
  void initState() {
    super.initState();
    _puzzle = crossbirdPuzzles[widget.puzzleIndex];
    _solved = List.filled(_puzzle.words.length, false);
    _lockedLetters = {};

    _confetti = ConfettiController(duration: const Duration(seconds: 3));

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _clueScrollController = ScrollController();

    // Build cell→word index map
    _cellToWordIndices = {};
    for (int i = 0; i < _puzzle.words.length; i++) {
      for (var cell in _puzzle.words[i].cells) {
        _cellToWordIndices.putIfAbsent(cell, () => []).add(i);
      }
    }

    // Deduplicate clue keys (e.g. 1-Across appears once per clue number+direction)
    _clueKeyToIndex = {};
    for (int i = 0; i < _puzzle.words.length; i++) {
      final w = _puzzle.words[i];
      final key = '${w.clueNumber}-${w.direction}';
      _clueKeyToIndex.putIfAbsent(key, () => i);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioService>().playQuizMusic();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    _shakeController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _clueScrollController.dispose();
    super.dispose();
  }

  // ─── Selection ───────────────────────────────────────────────────────────

  void _selectWordAt(int row, int col) {
    final indices = _cellToWordIndices[(row, col)];
    if (indices == null || indices.isEmpty) return;

    // Filter out already solved words if there's a choice
    final unsolved = indices.where((i) => !_solved[i]).toList();
    final candidates = unsolved.isNotEmpty ? unsolved : indices;

    int next;
    if (candidates.length == 1) {
      next = candidates.first;
    } else {
      // Cycle through candidates on repeated taps
      final currentIdx = candidates.indexOf(_selectedWordIndex ?? -1);
      next = candidates[(currentIdx + 1) % candidates.length];
    }

    _applySelection(next);
  }

  void _selectWordByIndex(int index) {
    _applySelection(index);
    _scrollToClue(index);
  }

  void _applySelection(int index) {
    if (_solved[index]) return;
    setState(() {
      _selectedWordIndex = index;
      _draftLetters = {};
      _textController.clear();
      _isWrong = false;
    });
    _focusNode.requestFocus();
  }

  void _scrollToClue(int index) {
    // Scroll clue list to show the selected item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemHeight = 64.0;
      final offset = index * itemHeight;
      if (_clueScrollController.hasClients) {
        _clueScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Input ───────────────────────────────────────────────────────────────

  void _onTextChanged(String text) {
    if (_selectedWordIndex == null) return;
    final word = _puzzle.words[_selectedWordIndex!];
    final chars = text.toUpperCase().replaceAll(' ', '').split('');

    setState(() {
      _isWrong = false;
      _draftLetters = {};
      for (int i = 0; i < chars.length && i < word.answer.length; i++) {
        _draftLetters[word.cells[i]] = chars[i];
      }
    });

    // Auto-submit when all letters filled
    if (chars.length >= word.answer.length) {
      _submitAnswer(chars.take(word.answer.length).join());
    }
  }

  void _submitAnswer([String? override]) {
    if (_selectedWordIndex == null) return;
    final word = _puzzle.words[_selectedWordIndex!];
    final typed = (override ?? _textController.text)
        .toUpperCase()
        .replaceAll(' ', '');

    if (typed == word.answer) {
      _onCorrect(_selectedWordIndex!);
    } else {
      _onWrong();
    }
  }

  void _onCorrect(int wordIndex) {
    context.read<AudioService>().playCorrectSound();
    final word = _puzzle.words[wordIndex];

    setState(() {
      _solved[wordIndex] = true;
      // Lock letters into the grid
      for (var cell in word.cells) {
        _lockedLetters[cell] = word.answer[word.cells.indexOf(cell)];
      }
      _draftLetters = {};
      _textController.clear();
      _selectedWordIndex = null;
      _isWrong = false;
    });

    // Track solved count
    context.read<QuizProvider>().incrementCrosswordsSolved();

    final solvedCount = _solved.where((s) => s).length;
    if (solvedCount == _puzzle.words.length) {
      _onAllSolved();
    } else {
      // Auto-advance to next unsolved word
      int nextIdx = -1;
      for (int i = 0; i < _puzzle.words.length; i++) {
        if (!_solved[i]) { nextIdx = i; break; }
      }
      if (nextIdx != -1) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _selectWordByIndex(nextIdx);
        });
      }
    }
  }

  void _onWrong() {
    HapticFeedback.mediumImpact();
    context.read<AudioService>().playWrongSound();
    setState(() => _isWrong = true);
    _shakeController.forward(from: 0);
    _textController.clear();
    setState(() => _draftLetters = {});
  }

  void _onAllSolved() {
    setState(() => _allDone = true);
    _confetti.play();
    context.read<AudioService>().playQuizCompleteSound();

    final provider = context.read<QuizProvider>();
    final solvedCount = _solved.where((s) => s).length;
    provider.saveCrossbirdsStars(
      widget.puzzleIndex,
      solvedCount,
      _puzzle.words.length,
    );

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      }
    });
  }

  // ─── Grid helpers ────────────────────────────────────────────────────────

  String? _letterAt(int row, int col) {
    final cell = (row, col);
    if (_lockedLetters.containsKey(cell)) return _lockedLetters[cell];
    if (_draftLetters.containsKey(cell)) return _draftLetters[cell];
    return null;
  }

  bool _cellActive(int row, int col) =>
      _cellToWordIndices.containsKey((row, col));

  bool _cellSelected(int row, int col) {
    if (_selectedWordIndex == null) return false;
    return _puzzle.words[_selectedWordIndex!].cells.contains((row, col));
  }

  bool _cellSolved(int row, int col) =>
      _lockedLetters.containsKey((row, col));

  int? _cellNumber(int row, int col) {
    for (final w in _puzzle.words) {
      if (w.startRow == row && w.startCol == col) return w.clueNumber;
    }
    return null;
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final solvedCount = _solved.where((s) => s).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F0),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, solvedCount),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildGrid(),
                          const SizedBox(height: 16),
                          _buildInputPanel(),
                          const SizedBox(height: 12),
                          _buildClueList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.teal,
                Colors.blue,
                Colors.amber,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int solvedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          NavigationUtils.buildBackButton(context, color: Colors.black87),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Crossbird: ${_puzzle.title}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                Text(
                  '$solvedCount / ${_puzzle.words.length} words',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          _buildCompletionBadge(solvedCount),
          const SizedBox(width: 8),
          NavigationUtils.buildProfileMenu(context, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildCompletionBadge(int solvedCount) {
    final pct = (solvedCount / _puzzle.words.length * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$pct%',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    const double gap = 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth - 8; // subtract outer padding
        final cellSize = ((maxWidth - gap * _puzzle.cols) / _puzzle.cols)
            .clamp(24.0, 42.0);
        return _buildGridWithCellSize(cellSize, gap);
      },
    );
  }

  Widget _buildGridWithCellSize(double cellSize, double gap) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_puzzle.rows, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_puzzle.cols, (col) {
                return Padding(
                  padding: EdgeInsets.all(gap / 2),
                  child: _buildCell(row, col, cellSize),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCell(int row, int col, double size) {
    final active = _cellActive(row, col);
    if (!active) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey[800],
      );
    }

    final selected = _cellSelected(row, col);
    final solved = _cellSolved(row, col);
    final letter = _letterAt(row, col);
    final number = _cellNumber(row, col);

    Color bgColor;
    Color borderColor;
    if (solved) {
      bgColor = const Color(0xFFB8F0C0);
      borderColor = Colors.green;
    } else if (selected) {
      bgColor = const Color(0xFFD0E8FF);
      borderColor = Colors.blue;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey[400]!;
    }

    return GestureDetector(
      onTap: () {
        context.read<AudioService>().playLetterTap();
        _selectWordAt(row, col);
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          double dx = 0;
          if (_isWrong && selected) {
            dx = 6 *
                (0.5 - (_shakeAnimation.value * 4 % 1).abs()).sign *
                _shakeAnimation.value;
          }
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Stack(
            children: [
              if (number != null)
                Positioned(
                  top: 1,
                  left: 2,
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: solved ? Colors.green[800] : Colors.grey[700],
                    ),
                  ),
                ),
              Center(
                child: Text(
                  letter ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: solved
                        ? Colors.green[900]
                        : (_isWrong && selected
                            ? Colors.red
                            : Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputPanel() {
    final word =
        _selectedWordIndex != null ? _puzzle.words[_selectedWordIndex!] : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: word != null ? Colors.teal : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: word != null ? 0.1 : 0),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: word == null
          ? Center(
              child: Text(
                _allDone
                    ? '🎉 Puzzle Complete!'
                    : 'Tap a square or clue to start',
                style: TextStyle(
                  color: _allDone ? Colors.green : Colors.grey[500],
                  fontSize: 15,
                  fontWeight:
                      _allDone ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        word.clue,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: word.answer.length,
                        decoration: InputDecoration(
                          hintText:
                              '${word.answer.length} letters...',
                          filled: true,
                          fillColor: _isWrong
                              ? Colors.red[50]
                              : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _isWrong ? Colors.red : Colors.teal,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _isWrong
                                  ? Colors.red
                                  : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _isWrong ? Colors.red : Colors.teal,
                              width: 2,
                            ),
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                        onChanged: _onTextChanged,
                        onSubmitted: (_) => _submitAnswer(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Check',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildClueList() {
    // Group and sort clues: across first, then down, by clueNumber
    final acrossWords = _puzzle.words
        .asMap()
        .entries
        .where((e) => e.value.direction == 'across')
        .toList()
      ..sort((a, b) => a.value.clueNumber.compareTo(b.value.clueNumber));
    final downWords = _puzzle.words
        .asMap()
        .entries
        .where((e) => e.value.direction == 'down')
        .toList()
      ..sort((a, b) => a.value.clueNumber.compareTo(b.value.clueNumber));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClueSection('ACROSS', acrossWords),
          Divider(height: 1, color: Colors.grey[200]),
          _buildClueSection('DOWN', downWords),
        ],
      ),
    );
  }

  Widget _buildClueSection(
    String title,
    List<MapEntry<int, CrossbirdWord>> entries,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.5,
              color: Colors.teal,
            ),
          ),
        ),
        ...entries.map((entry) => _buildClueItem(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildClueItem(int index, CrossbirdWord word) {
    final isSelected = _selectedWordIndex == index;
    final isSolved = _solved[index];

    return InkWell(
      onTap: isSolved ? null : () => _selectWordByIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: isSelected
            ? Colors.teal.withValues(alpha: 0.08)
            : Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${word.clueNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isSelected ? Colors.teal : Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: Text(
                word.clue,
                style: TextStyle(
                  fontSize: 14,
                  color: isSolved
                      ? Colors.green[700]
                      : (isSelected ? Colors.teal[900] : Colors.grey[800]),
                  decoration:
                      isSolved ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isSolved)
              Icon(Icons.check_circle_rounded,
                  color: Colors.green[400], size: 18),
          ],
        ),
      ),
    );
  }
}

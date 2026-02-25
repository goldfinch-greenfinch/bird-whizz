import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart'; // Removed
import '../models/question.dart';
import '../models/level.dart';
import '../models/user_profile.dart';

import '../data/sections/trivia_data.dart';
import '../data/sections/biology_data.dart';
import '../data/sections/habitat_data.dart';
import '../data/sections/conservation_data.dart';
import '../data/sections/behaviour_data.dart';
import '../data/sections/families_data.dart';
import '../data/sections/migration_data.dart';
import '../data/sections/colours_data.dart';
import '../services/bird_image_service.dart';

class QuizProvider with ChangeNotifier {
  List<UserProfile> _profiles = [];
  UserProfile? _currentProfile;

  // Level Up State
  String? _oldLevelTitle;
  String? _newLevelTitle;

  // Game Session State
  String _currentCategory = 'trivia'; // Default category
  Level? _currentLevel;
  List<Question> _activeQuestions =
      []; // Active list of 10 sampled questions with shuffled answers
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerProcessing = false;

  // Initialize SharedPreferences
  QuizProvider();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = prefs.getString('user_profiles');

    if (profilesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(profilesJson);
        _profiles = decoded.map((json) => UserProfile.fromJson(json)).toList();
      } catch (e) {
        // print('Error loading profiles: $e');
      }
    }

    // Attempt to restore last session if needed, but for now we start at profile selection
    notifyListeners();
  }

  Future<void> _saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _profiles.map((p) => p.toJson()).toList(),
    );
    await prefs.setString('user_profiles', encoded);
  }

  // --- Profile Management ---

  List<UserProfile> get profiles => List.unmodifiable(_profiles);
  UserProfile? get currentProfile => _currentProfile;
  bool get hasProfile => _currentProfile != null;

  bool isBirdTaken(String birdId) {
    return _profiles.any((p) => p.companionBirdId == birdId);
  }

  Future<void> createProfile(String name, String birdId) async {
    if (isBirdTaken(birdId)) {
      throw Exception('This bird is already taken by another adventurer!');
    }

    final newProfile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple ID
      name: name,
      companionBirdId: birdId,
    );

    _profiles.add(newProfile);
    _currentProfile = newProfile;
    await _saveProfiles();
    notifyListeners();
  }

  Future<void> selectProfile(String id) async {
    try {
      _currentProfile = _profiles.firstWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      // print('Profile not found: $id');
    }
  }

  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    if (_currentProfile?.id == id) {
      _currentProfile = null;
    }
    await _saveProfiles();
    notifyListeners();
  }

  // --- Category Management ---

  void selectCategory(String category) {
    _currentCategory = category;
    notifyListeners();
  }

  String get currentCategory => _currentCategory;

  List<Level> get allLevels {
    switch (_currentCategory) {
      case 'trivia':
        return triviaLevels;
      case 'biology':
        return biologyLevels;
      case 'habitat':
        return habitatLevels;
      case 'conservation':
        return conservationLevels;
      case 'behaviour':
        return behaviourLevels;
      case 'families':
        return familiesLevels;
      case 'migration':
        return migrationLevels;
      case 'colours':
        return coloursLevels;
      default:
        return triviaLevels;
    }
  }

  List<Level> get _allLevelsGlobally => [
    ...triviaLevels,
    ...biologyLevels,
    ...habitatLevels,
    ...conservationLevels,
    ...behaviourLevels,
    ...familiesLevels,
    ...migrationLevels,
    ...coloursLevels,
  ];

  List<Level> getLevelsForCategory(String category) {
    switch (category) {
      case 'trivia':
        return triviaLevels;
      case 'biology':
        return biologyLevels;
      case 'habitat':
        return habitatLevels;
      case 'conservation':
        return conservationLevels;
      case 'behaviour':
        return behaviourLevels;
      case 'families':
        return familiesLevels;
      case 'migration':
        return migrationLevels;
      case 'colours':
        return coloursLevels;
      default:
        return [];
    }
  }

  // Define category order for stats
  final List<String> _categoryOrder = [
    'trivia',
    'habitat',
    'behaviour',
    'colours',
    'families',
    'migration',
    'biology',
    'conservation',
  ];

  // --- Category Specific Stats ---

  int get categoryStars => getStarsForCategory(_currentCategory);

  int getStarsForCategory(String category) {
    int total = 0;
    for (var level in getLevelsForCategory(category)) {
      total += _levelStars[level.id] ?? 0;
    }
    return total;
  }

  int get categoryMaxStars => allLevels.length * 3;

  int get categoryCompletedLevels {
    int count = 0;
    for (var level in allLevels) {
      if ((_levelStars[level.id] ?? 0) > 0) count++;
    }
    return count;
  }

  // --- Section Unlocking Logic ---

  /// Returns 0, 1, 2, or 3 stars for the SECTION based on criteria:
  /// 1 Star: All levels have at least 1 star.
  /// 2 Stars: Total stars > (num_levels * 2).
  /// 3 Stars: Total stars == (num_levels * 3).
  int getSectionStarRating(String category) {
    final levels = getLevelsForCategory(category);
    if (levels.isEmpty) return 0;

    int totalStars = 0;
    bool allLevelsStarted = true;
    bool allLevelsPerfect = true;

    for (var level in levels) {
      final stars = _levelStars[level.id] ?? 0;
      totalStars += stars;
      if (stars < 1) allLevelsStarted = false;
      if (stars < 3) allLevelsPerfect = false;
    }

    if (allLevelsPerfect) return 3;
    if (totalStars > (levels.length * 2)) return 2;
    if (allLevelsStarted) return 1;

    return 0;
  }

  // --- Game State Getters (proxied to current profile) ---

  Map<String, int> get _levelStars => _currentProfile?.levelStars ?? {};

  // Helpers to update current profile safely
  void _updateCurrentProfile({
    Map<String, int>? levelStars,
    int? totalCorrectAnswers,
    Map<String, int>? categoryCorrectAnswers,
    int? birdIdHighScore,
    Map<String, int>? wordGameHighScores,
  }) {
    if (_currentProfile == null) return;

    int index = _profiles.indexWhere((p) => p.id == _currentProfile!.id);
    if (index != -1) {
      _profiles[index] = _currentProfile!.copyWith(
        levelStars: levelStars,
        totalCorrectAnswers: totalCorrectAnswers,
        categoryCorrectAnswers: categoryCorrectAnswers,
        birdIdHighScore: birdIdHighScore,
        wordGameHighScores: wordGameHighScores,
      );
      _currentProfile = _profiles[index];
      _saveProfiles(); // Save on every update
      notifyListeners();
    }
  }

  // --- Word Games ---
  int get unscrambleHighScore =>
      _currentProfile?.wordGameHighScores['unscramble'] ?? 0;

  void updateUnscrambleHighScore(int score) {
    if (_currentProfile == null) return;
    if (score > unscrambleHighScore) {
      final newHighScores = Map<String, int>.from(
        _currentProfile?.wordGameHighScores ?? {},
      );
      newHighScores['unscramble'] = score;
      _updateCurrentProfile(wordGameHighScores: newHighScores);
    }
  }

  String? get selectedBirdId => _currentProfile?.companionBirdId;

  // Stats
  int get totalCorrectAnswers => _currentProfile?.totalCorrectAnswers ?? 0;
  int get birdIdHighScore => _currentProfile?.birdIdHighScore ?? 0;

  int get categoryTotalCorrectAnswers {
    if (_currentProfile == null) return 0;
    // For Bird ID, we store it under 'bird_id' key
    return _currentProfile!.categoryCorrectAnswers[_currentCategory] ?? 0;
  }

  int get completedCategoriesCount {
    int count = 0;
    for (var category in _categoryOrder) {
      if (getSectionStarRating(category) > 0) count++;
    }
    return count;
  }

  int get totalStars {
    int total = 0;
    _levelStars.forEach((_, stars) => total += stars);
    return total;
  }

  int get maxStars => _allLevelsGlobally.length * 3;

  int get completedLevelsCount {
    int count = 0;
    _levelStars.forEach((_, stars) {
      if (stars > 0) count++;
    });
    return count;
  }

  String get userStatusTitle => _getStatusTitleForStars(totalStars);

  String _getStatusTitleForStars(int starCount) {
    if (maxStars == 0) return 'Bird Newbie';
    double percentage = starCount / maxStars;

    if (percentage < 0.1) return 'Just Hatched';
    if (percentage < 0.2) return 'Feather Weight';
    if (percentage < 0.3) return 'Learning to Fly';
    if (percentage < 0.4) return 'Wingin\' It';
    if (percentage < 0.5) return 'Nest Builder';
    if (percentage < 0.6) return 'High Flyer';
    if (percentage < 0.7) return 'Eagle Eye';
    if (percentage < 0.8) return 'Owl-some';
    if (percentage < 0.9) return 'Hawk-wardly Good';
    return 'Bird Wizard';
  }

  // Level Up Getters and Actions
  String? get oldLevelTitle => _oldLevelTitle;
  String? get newLevelTitle => _newLevelTitle;

  bool get hasLeveledUp => _newLevelTitle != null;

  void consumeLevelUp() {
    _oldLevelTitle = null;
    _newLevelTitle = null;
    notifyListeners();
  }

  // --- Quiz Logic ---

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  Level? get currentLevel => _currentLevel;

  bool get isAnswerProcessing => _isAnswerProcessing;
  int get totalQuestions => _activeQuestions
      .length; // Exposed for UI to know session length (should always be 10)

  int getStarsForLevel(String levelId) {
    return _levelStars[levelId] ?? 0;
  }

  bool isLevelUnlocked(String levelId) {
    // Determine which list this level belongs to for logic
    // But actually, we only render 'allLevels' (current category), so we just check that list.
    List<Level> currentCatLevels = allLevels;

    // If it's the first level of the CURRENT category, it's unlocked.
    if (currentCatLevels.isNotEmpty && currentCatLevels.first.id == levelId) {
      return true;
    }

    int index = currentCatLevels.indexWhere((l) => l.id == levelId);
    if (index > 0) {
      String prevLevelId = currentCatLevels[index - 1].id;
      return getStarsForLevel(prevLevelId) >= 2;
    }

    // If not found in current category (shouldn't happen in UI), lock it
    return false;
  }

  bool get isQuizFinished {
    if (_currentLevel == null) return true;
    return _currentQuestionIndex >= _activeQuestions.length;
  }

  Question get currentQuestion {
    if (_currentLevel == null || _activeQuestions.isEmpty) {
      // Fallback
      return allLevels.first.questions.first;
    }
    if (_currentQuestionIndex >= _activeQuestions.length) {
      return _activeQuestions.last;
    }
    return _activeQuestions[_currentQuestionIndex];
  }

  // Actions
  Future<void> startBirdIdQuiz([
    String? theme,
    String difficulty = 'medium',
  ]) async {
    // Initialize service if not already
    await BirdImageService().initialize();

    // Generate questions
    final questions = BirdImageService().generateQuestions(
      count: 10,
      theme: theme,
      difficulty: difficulty,
    );
    // debugPrint('QuizProvider: Generated ${questions.length} questions for Bird ID (Theme: $theme, Diff: $difficulty).');

    // Create dummy level
    final birdIdLevel = Level(
      id: 'bird_id_session_${theme ?? "all"}_$difficulty',
      name: '${theme ?? "Bird ID Challenge"} ($difficulty)',
      // description: 'Identify the birds!', // Not in Level model
      questions: questions,
      requiredScoreToUnlock: 0,
    );

    _currentCategory = 'bird_id';
    startLevel(birdIdLevel, isBirdIdMode: true);
  }

  void startLevel(Level level, {bool isBirdIdMode = false}) {
    _currentLevel = level;
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    _isAnswerProcessing = false;
    _oldLevelTitle = null; // Clear level up state on new level
    _newLevelTitle = null;

    // 1. Shuffle all questions from the level
    // If Bird ID mode, questions are already randomized by the service
    var questionsToUse = level.questions;
    if (!isBirdIdMode) {
      questionsToUse = List<Question>.from(level.questions)..shuffle();
    }

    // 2. Take top 10 (or less if not enough exist, though we should have 15)
    var sampledQuestions = questionsToUse.take(10).toList();

    // 3. For each sampled question, we randomize the options and track the correct answer
    _activeQuestions = sampledQuestions.map((q) {
      final originalCorrectOption = q.options[q.correctOptionIndex];
      final scrambledOptions = List<String>.from(q.options)..shuffle();
      final newCorrectIndex = scrambledOptions.indexOf(originalCorrectOption);

      return Question(
        id: q.id,
        text: q.text,
        imagePath: q.imagePath,
        options: scrambledOptions,
        correctOptionIndex: newCorrectIndex,
      );
    }).toList();

    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_isAnswerProcessing || _selectedAnswerIndex != null) return;

    _selectedAnswerIndex = index;
    _isAnswerProcessing = true;

    if (_selectedAnswerIndex == currentQuestion.correctOptionIndex) {
      _score++;
      // Update Total Correct immediately
      Map<String, int> newCategoryCorrect = Map<String, int>.from(
        _currentProfile?.categoryCorrectAnswers ?? {},
      );

      // Update global total and category total
      // Use 'bird_id' as category key for Bird ID mode
      String categoryKey = _currentCategory; // 'bird_id' or others

      newCategoryCorrect[categoryKey] =
          (newCategoryCorrect[categoryKey] ?? 0) + 1;

      _updateCurrentProfile(
        totalCorrectAnswers: totalCorrectAnswers + 1,
        categoryCorrectAnswers: newCategoryCorrect,
      );
    }

    notifyListeners();

    Timer(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_currentLevel != null) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _isAnswerProcessing = false;

      if (isQuizFinished) {
        _handleLevelCompletion();
      }

      notifyListeners();
    }
  }

  void _handleLevelCompletion() {
    if (_currentLevel != null) {
      if (_currentCategory == 'bird_id') {
        // Handle Bird ID High Score
        if (_score > birdIdHighScore) {
          _updateCurrentProfile(birdIdHighScore: _score);
        }
      } else {
        // Handle Standard Levels
        int totalCurrentQuestions = _activeQuestions.length;
        int stars;

        if (_score == totalCurrentQuestions) {
          stars = 3;
        } else if (_score >= 8) {
          stars = 2;
        } else if (_score >= 6) {
          stars = 1;
        } else {
          stars = 0;
        }

        int currentStars = _levelStars[_currentLevel!.id] ?? 0;
        if (stars > currentStars) {
          // Capture old status
          int oldTotalStars = totalStars;
          String oldTitle = _getStatusTitleForStars(oldTotalStars);

          // Update stars
          // Create new copy of map
          final newStars = Map<String, int>.from(_levelStars);
          newStars[_currentLevel!.id] = stars;
          _updateCurrentProfile(levelStars: newStars);

          // Check for Level Up
          // We need to fetch totalStars again as it's a computed property based on the updated profile
          int newTotalStars = totalStars;
          String newTitle = _getStatusTitleForStars(newTotalStars);

          if (newTitle != oldTitle) {
            _oldLevelTitle = oldTitle;
            _newLevelTitle = newTitle;

            int projectedTotal = oldTotalStars - currentStars + stars;
            String projectedTitle = _getStatusTitleForStars(projectedTotal);

            if (projectedTitle != oldTitle) {
              _oldLevelTitle = oldTitle;
              _newLevelTitle = projectedTitle;
            }
          }
        }
      }
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    _isAnswerProcessing = false;
    notifyListeners();
  }
}

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart'; // Removed
import '../models/question.dart';
import '../models/level.dart';
import '../models/user_profile.dart';
import '../models/stamp.dart';

import '../data/sections/trivia_data.dart';
import '../data/sections/biology_data.dart';
import '../data/sections/habitat_data.dart';
import '../data/sections/conservation_data.dart';
import '../data/sections/behaviour_data.dart';
import '../data/sections/families_data.dart';
import '../data/sections/migration_data.dart';
import '../data/sections/colours_data.dart';
import '../services/bird_image_service.dart';

class QuizProvider with ChangeNotifier, WidgetsBindingObserver {
  List<UserProfile> _profiles = [];
  UserProfile? _currentProfile;
  DateTime? _sessionStartTime;

  String? _oldLevelTitle;
  String? _newLevelTitle;
  int? _oldEvolutionStage;
  int? _newEvolutionStage;

  // Stamps
  final List<Stamp> _newlyUnlockedStamps = [];

  // Game Session State
  String _currentCategory = 'trivia'; // Default category
  Level? _currentLevel;
  List<Question> _activeQuestions =
      []; // Active list of 10 sampled questions with shuffled answers
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerProcessing = false;
  int? _wordGameTotalQuestions;

  // Initialize SharedPreferences
  QuizProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sessionStartTime = DateTime.now();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (_sessionStartTime != null && _currentProfile != null) {
        final diff = DateTime.now().difference(_sessionStartTime!).inSeconds;
        int index = _profiles.indexWhere((p) => p.id == _currentProfile!.id);
        if (index != -1) {
          _profiles[index] = _currentProfile!.copyWith(
            totalTimePlayingSeconds:
                _currentProfile!.totalTimePlayingSeconds + diff,
          );
          _currentProfile = _profiles[index];
          _saveProfiles();
        }
      }
      _sessionStartTime = null;
    }
  }

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
    _sessionStartTime = DateTime.now();
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
      firstPlayDate: DateTime.now(),
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
    int? totalTimePlayingSeconds,
    int? totalUnscrambledWords,
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
        totalTimePlayingSeconds: totalTimePlayingSeconds,
        totalUnscrambledWords: totalUnscrambledWords,
      );
      _currentProfile = _profiles[index];
      _saveProfiles(); // Save on every update

      _checkStamps(); // Check for unlocked stamps when profile updates

      notifyListeners();
    }
  }

  // --- Stamp Checking Logic ---
  List<Stamp> get newlyUnlockedStamps =>
      List.unmodifiable(_newlyUnlockedStamps);
  List<String> get unlockedStamps => _currentProfile?.unlockedStamps ?? [];

  void consumeNewlyUnlockedStamps() {
    _newlyUnlockedStamps.clear();
    notifyListeners();
  }

  void _checkStamps() {
    if (_currentProfile == null) return;

    List<String> currentStamps = List.from(_currentProfile!.unlockedStamps);
    bool newlyUnlocked = false;

    // First Flight
    if (!currentStamps.contains('first_flight') && completedLevelsCount > 0) {
      _unlockStamp('first_flight', currentStamps);
      newlyUnlocked = true;
    }

    // Dedicated Watcher
    if (!currentStamps.contains('dedicated_watcher') &&
        totalTimePlayingSeconds >= 3600) {
      _unlockStamp('dedicated_watcher', currentStamps);
      newlyUnlocked = true;
    }

    // Trivia Master
    if (!currentStamps.contains('trivia_master') && totalCorrectAnswers >= 50) {
      _unlockStamp('trivia_master', currentStamps);
      newlyUnlocked = true;
    }

    // Vocab Virtuoso
    if (!currentStamps.contains('vocab_virtuoso') &&
        totalUnscrambledWords >= 20) {
      _unlockStamp('vocab_virtuoso', currentStamps);
      newlyUnlocked = true;
    }

    // Perfectionist
    if (!currentStamps.contains('perfectionist')) {
      bool hasThreeStars = _levelStars.values.any((stars) => stars >= 3);
      if (hasThreeStars) {
        _unlockStamp('perfectionist', currentStamps);
        newlyUnlocked = true;
      }
    }

    // Identification Expert
    if (!currentStamps.contains('identification_expert') &&
        birdIdHighScore >= 50) {
      _unlockStamp('identification_expert', currentStamps);
      newlyUnlocked = true;
    }

    // Century Club
    if (!currentStamps.contains('century_club') && totalCorrectAnswers >= 100) {
      _unlockStamp('century_club', currentStamps);
      newlyUnlocked = true;
    }

    // Marathon Flyer
    if (!currentStamps.contains('marathon_flyer') &&
        totalCorrectAnswers >= 500) {
      _unlockStamp('marathon_flyer', currentStamps);
      newlyUnlocked = true;
    }

    // New stamps
    if (!currentStamps.contains('avian_apprentice') && totalStars >= 100) {
      _unlockStamp('avian_apprentice', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('master_ornithologist') && totalStars >= 250) {
      _unlockStamp('master_ornithologist', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('flock_starter') &&
        completedLevelsCount >= 10) {
      _unlockStamp('flock_starter', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('quiz_whiz') && totalCorrectAnswers >= 250) {
      _unlockStamp('quiz_whiz', currentStamps);
      newlyUnlocked = true;
    }

    // --- Newly Added Stamps ---
    // Star Collector
    if (!currentStamps.contains('star_collector') && totalStars >= 10) {
      _unlockStamp('star_collector', currentStamps);
      newlyUnlocked = true;
    }

    // Flawless Flyer
    if (!currentStamps.contains('flawless_flyer')) {
      int flawlessCount = _levelStars.values
          .where((stars) => stars >= 3)
          .length;
      if (flawlessCount >= 10) {
        _unlockStamp('flawless_flyer', currentStamps);
        newlyUnlocked = true;
      }
    }

    // Dedicated Birder
    if (!currentStamps.contains('dedicated_birder') &&
        completedLevelsCount >= 50) {
      _unlockStamp('dedicated_birder', currentStamps);
      newlyUnlocked = true;
    }

    // Legendary Watcher
    if (!currentStamps.contains('legendary_watcher') &&
        totalCorrectAnswers >= 1000) {
      _unlockStamp('legendary_watcher', currentStamps);
      newlyUnlocked = true;
    }

    // Scramble Champion
    if (!currentStamps.contains('scramble_champion') &&
        totalUnscrambledWords >= 50) {
      _unlockStamp('scramble_champion', currentStamps);
      newlyUnlocked = true;
    }

    // ID Master
    if (!currentStamps.contains('id_master') && birdIdHighScore >= 100) {
      _unlockStamp('id_master', currentStamps);
      newlyUnlocked = true;
    }

    // --- 20 New Varied Stamps ---
    // Time base
    if (!currentStamps.contains('time_flies') &&
        totalTimePlayingSeconds >= 36000) {
      _unlockStamp('time_flies', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('frequent_flyer') &&
        totalTimePlayingSeconds >= 86400) {
      _unlockStamp('frequent_flyer', currentStamps);
      newlyUnlocked = true;
    }

    // Question totals
    if (!currentStamps.contains('smart_cookie') &&
        totalCorrectAnswers >= 2000) {
      _unlockStamp('smart_cookie', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('know_it_owl') && totalCorrectAnswers >= 5000) {
      _unlockStamp('know_it_owl', currentStamps);
      newlyUnlocked = true;
    }

    // Stars & Levels
    if (!currentStamps.contains('constellation') && totalStars >= 350) {
      _unlockStamp('constellation', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('level_100') && completedLevelsCount >= 100) {
      _unlockStamp('level_100', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('flawless_flock')) {
      int flawlessCount = _levelStars.values
          .where((stars) => stars >= 3)
          .length;
      if (flawlessCount >= 50) {
        _unlockStamp('flawless_flock', currentStamps);
        newlyUnlocked = true;
      }
    }

    // Word Games
    if (!currentStamps.contains('wordsmith') && totalUnscrambledWords >= 250) {
      _unlockStamp('wordsmith', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('anagram_ace') &&
        totalUnscrambledWords >= 500) {
      _unlockStamp('anagram_ace', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('spelling_bee') && unscrambleHighScore >= 20) {
      _unlockStamp('spelling_bee', currentStamps);
      newlyUnlocked = true;
    }

    // Bird ID High Scores
    if (!currentStamps.contains('sharp_shooter') && birdIdHighScore >= 250) {
      _unlockStamp('sharp_shooter', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('hawk_eyed') && birdIdHighScore >= 500) {
      _unlockStamp('hawk_eyed', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('bird_paparazzi') && birdIdHighScore >= 1000) {
      _unlockStamp('bird_paparazzi', currentStamps);
      newlyUnlocked = true;
    }

    // Category Specific Correct Answers
    int getCatCorrect(String cat) =>
        _currentProfile?.categoryCorrectAnswers[cat] ?? 0;

    if (!currentStamps.contains('trivia_addict') &&
        getCatCorrect('trivia') >= 50) {
      _unlockStamp('trivia_addict', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('biology_buff') &&
        getCatCorrect('biology') >= 50) {
      _unlockStamp('biology_buff', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('habitat_hero') &&
        getCatCorrect('habitat') >= 50) {
      _unlockStamp('habitat_hero', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('conservation_champion') &&
        getCatCorrect('conservation') >= 50) {
      _unlockStamp('conservation_champion', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('behavior_boss') &&
        getCatCorrect('behaviour') >= 50) {
      _unlockStamp('behavior_boss', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('family_fanatic') &&
        getCatCorrect('families') >= 50) {
      _unlockStamp('family_fanatic', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('migration_marvel') &&
        getCatCorrect('migration') >= 50) {
      _unlockStamp('migration_marvel', currentStamps);
      newlyUnlocked = true;
    }

    // --- 10 Additional New Stamps ---
    if (!currentStamps.contains('colours_champ') &&
        getCatCorrect('colours') >= 50) {
      _unlockStamp('colours_champ', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('weekend_warrior') &&
        totalTimePlayingSeconds >= 172800) {
      _unlockStamp('weekend_warrior', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('flawless_master')) {
      int flawlessCount = _levelStars.values
          .where((stars) => stars >= 3)
          .length;
      if (flawlessCount >= 75) {
        _unlockStamp('flawless_master', currentStamps);
        newlyUnlocked = true;
      }
    }
    if (!currentStamps.contains('quiz_guru') && totalCorrectAnswers >= 10000) {
      _unlockStamp('quiz_guru', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('id_legend') && birdIdHighScore >= 2000) {
      _unlockStamp('id_legend', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('scramble_legend') &&
        totalUnscrambledWords >= 1000) {
      _unlockStamp('scramble_legend', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('spelling_master') &&
        unscrambleHighScore >= 30) {
      _unlockStamp('spelling_master', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('trivia_titan') &&
        getCatCorrect('trivia') >= 150) {
      _unlockStamp('trivia_titan', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('biology_brain') &&
        getCatCorrect('biology') >= 150) {
      _unlockStamp('biology_brain', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('habitat_hound') &&
        getCatCorrect('habitat') >= 150) {
      _unlockStamp('habitat_hound', currentStamps);
      newlyUnlocked = true;
    }

    // --- Section Completions ---
    final sectionStamps = {
      'trivia_complete': 'trivia',
      'biology_complete': 'biology',
      'habitat_complete': 'habitat',
      'conservation_complete': 'conservation',
      'behaviour_complete': 'behaviour',
      'families_complete': 'families',
      'migration_complete': 'migration',
      'colours_complete': 'colours',
    };

    sectionStamps.forEach((stampId, category) {
      if (!currentStamps.contains(stampId) &&
          getSectionStarRating(category) > 0) {
        _unlockStamp(stampId, currentStamps);
        newlyUnlocked = true;
      }
    });

    // --- Bird ID Complete (at least 1 star across the themes of a given difficulty) ---
    // The easiest way to check is to count completed levels that end with the difficulty
    // There are 10 themes per difficulty. So 10 levels ending in _easy means easy complete.
    int idEasyCount = 0;
    int idMedCount = 0;
    int idHardCount = 0;

    _levelStars.forEach((key, stars) {
      if (key.startsWith('bird_id_session_') && stars > 0) {
        if (key.endsWith('_easy')) {
          idEasyCount++;
        } else if (key.endsWith('_medium')) {
          idMedCount++;
        } else if (key.endsWith('_hard')) {
          idHardCount++;
        }
      }
    });

    if (!currentStamps.contains('id_easy_complete') && idEasyCount >= 10) {
      _unlockStamp('id_easy_complete', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('id_medium_complete') && idMedCount >= 10) {
      _unlockStamp('id_medium_complete', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('id_hard_complete') && idHardCount >= 10) {
      _unlockStamp('id_hard_complete', currentStamps);
      newlyUnlocked = true;
    }

    // --- Scramble Complete ---
    if (!currentStamps.contains('scramble_master') &&
        unscrambleCompletedLevels >= 5) {
      _unlockStamp('scramble_master', currentStamps);
      newlyUnlocked = true;
    }

    if (newlyUnlocked) {
      int index = _profiles.indexWhere((p) => p.id == _currentProfile!.id);
      if (index != -1) {
        _profiles[index] = _currentProfile!.copyWith(
          unlockedStamps: currentStamps,
        );
        _currentProfile = _profiles[index];
        _saveProfiles();
        notifyListeners();
      }
    }
  }

  void _unlockStamp(String id, List<String> currentStamps) {
    currentStamps.add(id);
    final stamp = gameStamps.firstWhere(
      (s) => s.id == id,
      orElse: () => gameStamps.first,
    );
    _newlyUnlockedStamps.add(stamp);
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

  void incrementUnscrambledWords() {
    if (_currentProfile == null) return;
    _updateCurrentProfile(
      totalUnscrambledWords: _currentProfile!.totalUnscrambledWords + 1,
    );
  }

  int get unscrambleTotalStars {
    int total = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('unscramble_')) total += stars;
    });
    return total;
  }

  int get unscrambleMaxStars => 5 * 3;

  int get unscrambleCompletedLevels {
    int count = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('unscramble_') && stars > 0) count++;
    });
    return count;
  }

  void saveWordGameStars(
    String levelTitle,
    int score, {
    int totalQuestions = 10,
  }) {
    if (_currentProfile == null) return;

    // Support using ResultScreen
    _score = score;
    _wordGameTotalQuestions = totalQuestions;

    int stars = 0;
    if (totalQuestions > 0) {
      double pct = score / totalQuestions;
      if (pct == 1.0) {
        stars = 3;
      } else if (pct >= 0.8) {
        stars = 2;
      } else if (pct >= 0.6) {
        stars = 1;
      }
    }

    String levelId = 'unscramble_$levelTitle';
    int currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      // Capture old status
      int oldTotalStars = totalStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      // Check for Level Up
      int newTotalStars = totalStars;
      String newTitle = _getStatusTitleForStars(newTotalStars);
      int newEvo = getEvolutionStageForStars(newTotalStars);

      if (newTitle != oldTitle) {
        _oldLevelTitle = oldTitle;
        _newLevelTitle = newTitle;
      }
      if (newEvo > oldEvo) {
        _oldEvolutionStage = oldEvo;
        _newEvolutionStage = newEvo;
      }
    }
  }

  // --- Bird ID Stars ---
  int get birdIdTotalStars {
    int total = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('bird_id_session_')) total += stars;
    });
    return total;
  }

  int get birdIdMaxStars =>
      10 * 3 * 3; // 10 themes * 3 difficulties * 3 stars = 90

  int get birdIdCompletedLevels {
    int count = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('bird_id_session_') && stars > 0) count++;
    });
    return count;
  }

  String? get selectedBirdId => _currentProfile?.companionBirdId;

  // Stats
  int get totalCorrectAnswers => _currentProfile?.totalCorrectAnswers ?? 0;
  int get birdIdHighScore => _currentProfile?.birdIdHighScore ?? 0;
  int get totalTimePlayingSeconds =>
      _currentProfile?.totalTimePlayingSeconds ?? 0;
  DateTime? get firstPlayDate => _currentProfile?.firstPlayDate;
  int get totalUnscrambledWords => _currentProfile?.totalUnscrambledWords ?? 0;

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
    _levelStars.forEach((_, stars) {
      total += stars;
    });
    return total;
  }

  // To update this properly as the game expands you simply need to tally the individual maxes:
  int get maxStars =>
      (_allLevelsGlobally.length * 3) + unscrambleMaxStars + birdIdMaxStars;

  int get completedLevelsCount {
    int count = 0;
    for (var level in _allLevelsGlobally) {
      if ((_levelStars[level.id] ?? 0) > 0) count++;
    }
    return count;
  }

  String get userStatusTitle => _getStatusTitleForStars(totalStars);

  String _getStatusTitleForStars(int starCount) {
    if (starCount < 3) return 'Just Hatched';
    if (starCount < 8) return 'Bird Newbie';
    if (starCount < 18) return 'Feather Weight';
    if (starCount < 35) return 'Learning to Fly';
    if (starCount < 60) return 'Nest Builder';
    if (starCount < 95) return 'Winging It';
    if (starCount < 140) return 'High Flyer';
    if (starCount < 200) return 'Eagle Eye';
    if (starCount < 275) return 'Owl-some';
    if (starCount < 370) return 'Hawk-wardly Good';
    return 'Bird Wizard';
  }

  int get userLevelIndex => getLevelIndexForStars(totalStars);

  int getLevelIndexForStars(int starCount) {
    if (starCount < 3) return 0;
    if (starCount < 8) return 1;
    if (starCount < 18) return 2;
    if (starCount < 35) return 3;
    if (starCount < 60) return 4;
    if (starCount < 95) return 5;
    if (starCount < 140) return 6;
    if (starCount < 200) return 7;
    if (starCount < 275) return 8;
    if (starCount < 370) return 9;
    return 10;
  }

  int get userEvolutionStage => getEvolutionStageForStars(totalStars);

  int getEvolutionStageForStars(int starCount) {
    return (getLevelIndexForStars(starCount) ~/ 2) + 1;
  }

  double get nextLevelProgress {
    int current = totalStars;
    int nextThreshold = _getNextLevelThreshold(current);
    int prevThreshold = _getPreviousLevelThreshold(current);

    if (current >= 370) return 1.0; // Max Level

    int range = nextThreshold - prevThreshold;
    int earnedInLevel = current - prevThreshold;

    return earnedInLevel / range;
  }

  int get currentStarsInLevel {
    int current = totalStars;
    if (current >= 370) return 0;
    int prevThreshold = _getPreviousLevelThreshold(current);
    return current - prevThreshold;
  }

  int get neededStarsForNextLevel {
    int current = totalStars;
    if (current >= 370) return 1; // Prevent 0/0 edgecase
    int nextThreshold = _getNextLevelThreshold(current);
    int prevThreshold = _getPreviousLevelThreshold(current);
    return nextThreshold - prevThreshold;
  }

  int _getNextLevelThreshold(int starCount) {
    if (starCount < 3) return 3;
    if (starCount < 8) return 8;
    if (starCount < 18) return 18;
    if (starCount < 35) return 35;
    if (starCount < 60) return 60;
    if (starCount < 95) return 95;
    if (starCount < 140) return 140;
    if (starCount < 200) return 200;
    if (starCount < 275) return 275;
    if (starCount < 370) return 370;
    return starCount; // Max
  }

  int _getPreviousLevelThreshold(int starCount) {
    if (starCount < 3) return 0;
    if (starCount < 8) return 3;
    if (starCount < 18) return 8;
    if (starCount < 35) return 18;
    if (starCount < 60) return 35;
    if (starCount < 95) return 60;
    if (starCount < 140) return 95;
    if (starCount < 200) return 140;
    if (starCount < 275) return 200;
    if (starCount < 370) return 275;
    return 370; // Max
  }

  // Level Up Getters and Actions
  String? get oldLevelTitle => _oldLevelTitle;
  String? get newLevelTitle => _newLevelTitle;
  int? get oldEvolutionStage => _oldEvolutionStage;
  int? get newEvolutionStage => _newEvolutionStage;

  bool get hasLeveledUp => _newLevelTitle != null;
  bool get hasEvolved =>
      _newEvolutionStage != null &&
      _oldEvolutionStage != null &&
      _newEvolutionStage! > _oldEvolutionStage!;

  void consumeLevelUp() {
    _oldLevelTitle = null;
    _newLevelTitle = null;
    _oldEvolutionStage = null;
    _newEvolutionStage = null;
    notifyListeners();
  }

  // --- Quiz Logic ---

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  Level? get currentLevel => _currentLevel;

  bool get isAnswerProcessing => _isAnswerProcessing;
  int get totalQuestions =>
      _wordGameTotalQuestions ??
      _activeQuestions
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
    _wordGameTotalQuestions = null;
    _oldLevelTitle = null; // Clear level up state on new level
    _newLevelTitle = null;
    _oldEvolutionStage = null;
    _newEvolutionStage = null;

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
      }

      // Handle Stars for all modes including Bird ID
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
        int oldEvo = getEvolutionStageForStars(oldTotalStars);

        // Update stars
        // Create new copy of map
        final newStars = Map<String, int>.from(_levelStars);
        newStars[_currentLevel!.id] = stars;
        _updateCurrentProfile(levelStars: newStars);

        // Check for Level Up
        // We need to fetch totalStars again as it's a computed property based on the updated profile
        int newTotalStars = totalStars;
        String newTitle = _getStatusTitleForStars(newTotalStars);
        int newEvo = getEvolutionStageForStars(newTotalStars);

        if (newTitle != oldTitle) {
          _oldLevelTitle = oldTitle;
          _newLevelTitle = newTitle;
        }
        if (newEvo > oldEvo) {
          _oldEvolutionStage = oldEvo;
          _newEvolutionStage = newEvo;
        }
      }
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    _isAnswerProcessing = false;
    _wordGameTotalQuestions = null;
    notifyListeners();
  }
}

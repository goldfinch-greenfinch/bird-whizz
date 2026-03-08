import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart'; // Removed
import '../models/question.dart';
import '../models/level.dart';
import '../models/user_profile.dart';
import '../models/stamp.dart';
import '../services/storage_service.dart';

import '../data/sections/trivia_data.dart';
import '../data/sections/biology_data.dart';
import '../data/sections/habitat_data.dart';
import '../data/sections/conservation_data.dart';
import '../data/sections/behaviour_data.dart';
import '../data/sections/families_data.dart';
import '../data/sections/migration_data.dart';
import '../data/sections/colours_data.dart';
import '../services/bird_image_service.dart';
import '../services/logging_service.dart';
import '../models/daily_question.dart';
import '../data/daily_questions_data.dart';

class QuizProvider with ChangeNotifier, WidgetsBindingObserver {
  final StorageService _storage;
  final Random _random = Random();
  List<UserProfile> _profiles = [];
  UserProfile? _currentProfile;
  DateTime? _sessionStartTime;

  String? _oldLevelTitle;
  String? _newLevelTitle;
  int? _oldEvolutionStage;
  int? _newEvolutionStage;

  bool _hasShownDailyChallengeThisSession = false;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

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

  // Endless Mode State
  bool _isEndlessMode = false;
  int _endlessStreak = 0;
  int _endlessStrikes = 0;
  int _endlessQuestionCount = 0;
  Question? _endlessCurrentQuestion;
  int _lastEndlessStreak = 0;

  QuizProvider(this._storage) {
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
    _profiles = await _storage.loadProfiles();
    _sessionStartTime = DateTime.now();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveProfiles() async {
    await _storage.saveProfiles(_profiles);
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
    _recordLogin();
    notifyListeners();
  }

  Future<void> selectProfile(String id) async {
    try {
      _currentProfile = _profiles.firstWhere((p) => p.id == id);
      _hasShownDailyChallengeThisSession = false; // Reset on profile change
      _recordLogin();
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

  // --- Daily Challenge Logic ---

  bool get isDailyChallengeAvailable {
    if (_currentProfile == null) return false;
    final lastCompleteDate = _currentProfile!.lastDailyChallengeDate;
    if (lastCompleteDate == null) return true;
    final now = DateTime.now();
    return !(lastCompleteDate.year == now.year &&
        lastCompleteDate.month == now.month &&
        lastCompleteDate.day == now.day);
  }

  bool get hasShownDailyChallengeThisSession =>
      _hasShownDailyChallengeThisSession;
  void markDailyChallengeShown() {
    _hasShownDailyChallengeThisSession = true;
  }

  DailyQuestion get dailyChallengeQuestion {
    final now = DateTime.now();
    // Simple way to pick one question per day of the year (0-364)
    final startOfYear = DateTime(now.year, 1, 1);
    int dayOfYear = now.difference(startOfYear).inDays;
    return dailyQuestions[dayOfYear % dailyQuestions.length];
  }

  void startDailyChallenge() {
    final dailyQ = dailyChallengeQuestion;
    final virtualQuestion = Question(
      id: dailyQ.id,
      text: dailyQ.text,
      options: dailyQ.options,
      correctOptionIndex: dailyQ.correctOptionIndex,
    );

    final dailyLevel = Level(
      id: 'daily_challenge_level',
      name: 'Daily Bird Challenge',
      questions: [virtualQuestion],
      requiredScoreToUnlock: 0,
    );

    _score = 0;
    _wordGameTotalQuestions = 1;
    _currentCategory = 'daily_challenge';
    startLevel(dailyLevel);
  }

  void _recordLogin() {
    if (_currentProfile == null) return;
    final now = DateTime.now();
    final lastLogin = _currentProfile!.lastLoginDate;

    int newStreak = _currentProfile!.currentLoginStreak;

    if (lastLogin != null) {
      final difference = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastLogin.year, lastLogin.month, lastLogin.day))
          .inDays;

      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
      // if difference == 0, already logged in today, do nothing.
      if (difference == 0) return;
    } else {
      newStreak = 1;
    }

    _updateCurrentProfile(lastLoginDate: now, currentLoginStreak: newStreak);
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
    int? totalRescuedBirds,
    int? totalCrosswordsSolved,
    int? totalGuessBirdBirdsGuessed,
    int? totalSpeedChallengeCorrect,
    DateTime? lastDailyChallengeDate,
    int? currentDailyStreak,
    int? totalDailyChallengesCompleted,
    DateTime? lastLoginDate,
    int? currentLoginStreak,
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
        totalRescuedBirds:
            totalRescuedBirds ?? _currentProfile!.totalRescuedBirds,
        totalCrosswordsSolved:
            totalCrosswordsSolved ?? _currentProfile!.totalCrosswordsSolved,
        totalGuessBirdBirdsGuessed:
            totalGuessBirdBirdsGuessed ??
            _currentProfile!.totalGuessBirdBirdsGuessed,
        totalSpeedChallengeCorrect:
            totalSpeedChallengeCorrect ??
            _currentProfile!.totalSpeedChallengeCorrect,
        lastDailyChallengeDate:
            lastDailyChallengeDate ?? _currentProfile!.lastDailyChallengeDate,
        currentDailyStreak:
            currentDailyStreak ?? _currentProfile!.currentDailyStreak,
        totalDailyChallengesCompleted:
            totalDailyChallengesCompleted ??
            _currentProfile!.totalDailyChallengesCompleted,
        lastLoginDate: lastLoginDate ?? _currentProfile!.lastLoginDate,
        currentLoginStreak:
            currentLoginStreak ?? _currentProfile!.currentLoginStreak,
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
    if (!currentStamps.contains('avian_apprentice') && progressStars >= 100) {
      _unlockStamp('avian_apprentice', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('master_ornithologist') && progressStars >= 250) {
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
    if (!currentStamps.contains('star_collector') && progressStars >= 10) {
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
    if (!currentStamps.contains('constellation') && progressStars >= 350) {
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

    // Crossbird
    final crossbirdSolvedCount = totalCrosswordsSolved;
    if (!currentStamps.contains('crossbird_first') &&
        crossbirdSolvedCount >= 1) {
      _unlockStamp('crossbird_first', currentStamps);
      newlyUnlocked = true;
    }
    final crossbirdPuzzlesCompleted = _levelStars.entries
        .where((e) => e.key.startsWith('crossbird_puzzle_') && e.value > 0)
        .length;
    if (!currentStamps.contains('crossbird_master') &&
        crossbirdPuzzlesCompleted >= 3) {
      _unlockStamp('crossbird_master', currentStamps);
      newlyUnlocked = true;
    }
    final crossbirdPerfectPuzzles = _levelStars.entries
        .where((e) => e.key.startsWith('crossbird_puzzle_') && e.value >= 3)
        .length;
    if (!currentStamps.contains('crossbird_perfectionist') &&
        crossbirdPerfectPuzzles >= 3) {
      _unlockStamp('crossbird_perfectionist', currentStamps);
      newlyUnlocked = true;
    }

    // Rescue the Bird
    if (!currentStamps.contains('rescue_rookie') && totalRescuedBirds >= 1) {
      _unlockStamp('rescue_rookie', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('rescue_ranger') && totalRescuedBirds >= 10) {
      _unlockStamp('rescue_ranger', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('rescue_hero') && totalRescuedBirds >= 25) {
      _unlockStamp('rescue_hero', currentStamps);
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

    // --- Daily Challenge Stamps ---
    int dailyCompleted = _currentProfile?.totalDailyChallengesCompleted ?? 0;
    if (!currentStamps.contains('daily_bonus_1') && dailyCompleted >= 1) {
      _unlockStamp('daily_bonus_1', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('daily_bonus_5') && dailyCompleted >= 5) {
      _unlockStamp('daily_bonus_5', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('daily_bonus_20') && dailyCompleted >= 20) {
      _unlockStamp('daily_bonus_20', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('daily_bonus_50') && dailyCompleted >= 50) {
      _unlockStamp('daily_bonus_50', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('daily_bonus_100') && dailyCompleted >= 100) {
      _unlockStamp('daily_bonus_100', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('daily_bonus_365') && dailyCompleted >= 365) {
      _unlockStamp('daily_bonus_365', currentStamps);
      newlyUnlocked = true;
    }

    // --- Login Streak Stamps ---
    int loginStreak = _currentProfile?.currentLoginStreak ?? 0;
    if (!currentStamps.contains('first_login') && loginStreak >= 1) {
      _unlockStamp('first_login', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('login_streak_3') && loginStreak >= 3) {
      _unlockStamp('login_streak_3', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('login_streak_7') && loginStreak >= 7) {
      _unlockStamp('login_streak_7', currentStamps);
      newlyUnlocked = true;
    }

    // --- Scramble Complete ---
    if (!currentStamps.contains('scramble_master') &&
        unscrambleCompletedLevels >= 5) {
      _unlockStamp('scramble_master', currentStamps);
      newlyUnlocked = true;
    }

    // --- Endless Mode Streak Stamps ---
    final int endlessBest = endlessHighScore;
    if (!currentStamps.contains('endless_streak_10') && endlessBest >= 10) {
      _unlockStamp('endless_streak_10', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('endless_streak_20') && endlessBest >= 20) {
      _unlockStamp('endless_streak_20', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('endless_streak_50') && endlessBest >= 50) {
      _unlockStamp('endless_streak_50', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('endless_streak_100') && endlessBest >= 100) {
      _unlockStamp('endless_streak_100', currentStamps);
      newlyUnlocked = true;
    }

    // --- Speed Challenge Stamps ---
    final speedCompletedLevels = _countSpeedChallengeLevels();
    if (!currentStamps.contains('speed_first') && speedCompletedLevels >= 1) {
      _unlockStamp('speed_first', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('speed_all_5') && speedCompletedLevels >= 5) {
      _unlockStamp('speed_all_5', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('speed_perfect')) {
      final hasSpeedPerfect = _levelStars.entries
          .any((e) => e.key.startsWith('speed_challenge_level_') && e.value >= 3);
      if (hasSpeedPerfect) {
        _unlockStamp('speed_perfect', currentStamps);
        newlyUnlocked = true;
      }
    }
    if (!currentStamps.contains('speed_legend_3stars')) {
      final legendStars = _levelStars['speed_challenge_level_4'] ?? 0;
      if (legendStars >= 3) {
        _unlockStamp('speed_legend_3stars', currentStamps);
        newlyUnlocked = true;
      }
    }

    // --- Guess the Bird Stamps ---
    if (!currentStamps.contains('guess_bird_first') &&
        guessBirdCompletedLevels >= 1) {
      _unlockStamp('guess_bird_first', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('guess_bird_all_5') &&
        guessBirdCompletedLevels >= 5) {
      _unlockStamp('guess_bird_all_5', currentStamps);
      newlyUnlocked = true;
    }
    if (!currentStamps.contains('guess_bird_perfect')) {
      final hasGuessBirdPerfect = _levelStars.entries
          .any((e) => e.key.startsWith('guess_bird_level_') && e.value >= 3);
      if (hasGuessBirdPerfect) {
        _unlockStamp('guess_bird_perfect', currentStamps);
        newlyUnlocked = true;
      }
    }
    if (!currentStamps.contains('guess_bird_legend')) {
      final legendStars = _levelStars['guess_bird_level_4'] ?? 0;
      if (legendStars >= 3) {
        _unlockStamp('guess_bird_legend', currentStamps);
        newlyUnlocked = true;
      }
    }

    // --- Companion Evolution Stamps ---
    // Stage 1: awarded immediately on completing the first level
    if (!currentStamps.contains('evolution_stage_1') &&
        completedLevelsCount >= 1) {
      _unlockStamp('evolution_stage_1', currentStamps);
      newlyUnlocked = true;
    }
    // Stage 2: reached when evolution stage advances to 2 (stars >= 18)
    if (!currentStamps.contains('evolution_stage_2') &&
        userEvolutionStage >= 2) {
      _unlockStamp('evolution_stage_2', currentStamps);
      newlyUnlocked = true;
    }
    // Stage 3: evolution stage 3 (stars >= 60)
    if (!currentStamps.contains('evolution_stage_3') &&
        userEvolutionStage >= 3) {
      _unlockStamp('evolution_stage_3', currentStamps);
      newlyUnlocked = true;
    }
    // Stage 4: evolution stage 4 (stars >= 140)
    if (!currentStamps.contains('evolution_stage_4') &&
        userEvolutionStage >= 4) {
      _unlockStamp('evolution_stage_4', currentStamps);
      newlyUnlocked = true;
    }
    // Stage 5: evolution stage 5 (stars >= 275)
    if (!currentStamps.contains('evolution_stage_5') &&
        userEvolutionStage >= 5) {
      _unlockStamp('evolution_stage_5', currentStamps);
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

  int get endlessHighScore =>
      _currentProfile?.wordGameHighScores['endless'] ?? 0;

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

  void updateEndlessHighScore(int streak) {
    if (_currentProfile == null) return;
    if (streak > endlessHighScore) {
      final newHighScores = Map<String, int>.from(
        _currentProfile?.wordGameHighScores ?? {},
      );
      newHighScores['endless'] = streak;
      _updateCurrentProfile(wordGameHighScores: newHighScores);
    }
  }

  void incrementUnscrambledWords() {
    if (_currentProfile == null) return;
    _updateCurrentProfile(
      totalUnscrambledWords: _currentProfile!.totalUnscrambledWords + 1,
    );
  }

  void incrementRescuedBirds() {
    if (_currentProfile == null) return;
    _updateCurrentProfile(
      totalRescuedBirds: _currentProfile!.totalRescuedBirds + 1,
    );
  }

  void incrementCrosswordsSolved() {
    if (_currentProfile == null) return;
    _updateCurrentProfile(
      totalCrosswordsSolved: _currentProfile!.totalCrosswordsSolved + 1,
    );
  }

  int get totalCrosswordsSolved =>
      _currentProfile?.totalCrosswordsSolved ?? 0;

  void saveCrossbirdsStars(
    int puzzleIndex,
    int solvedWords,
    int totalWords,
  ) {
    if (_currentProfile == null) return;

    _score = solvedWords;
    _wordGameTotalQuestions = totalWords;

    int stars = 0;
    if (totalWords > 0) {
      final pct = solvedWords / totalWords;
      if (pct == 1.0) {
        stars = 3;
      } else if (pct >= 0.8) {
        stars = 2;
      } else if (pct >= 0.5) {
        stars = 1;
      }
    }

    final String levelId = 'crossbird_puzzle_$puzzleIndex';
    final int currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      int newTotalStars = progressStars;
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

  int get crossbirdTotalStars {
    int total = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('crossbird_puzzle_')) total += stars;
    });
    return total;
  }

  int get crossbirdMaxStars => 4 * 3; // 4 puzzles * 3 stars

  // --- Guess the Bird Stats ---
  int get guessBirdTotalStars {
    int total = 0;
    for (int i = 0; i < 5; i++) {
      total += _levelStars['guess_bird_level_$i'] ?? 0;
    }
    return total;
  }

  int get guessBirdMaxStars => 5 * 3; // 5 levels * 3 stars

  int get guessBirdCompletedLevels {
    int count = 0;
    for (int i = 0; i < 5; i++) {
      if ((_levelStars['guess_bird_level_$i'] ?? 0) > 0) count++;
    }
    return count;
  }

  int get guessBirdTotalGuessed =>
      _currentProfile?.totalGuessBirdBirdsGuessed ?? 0;

  void finishGuessBirdLevel(int levelIndex, int score, int total) {
    if (_currentProfile == null) return;

    _score = score;
    _wordGameTotalQuestions = total;
    _currentCategory = 'guess_bird';
    _oldLevelTitle = null;
    _newLevelTitle = null;
    _oldEvolutionStage = null;
    _newEvolutionStage = null;

    // Record total birds guessed correctly
    _updateCurrentProfile(
      totalGuessBirdBirdsGuessed:
          _currentProfile!.totalGuessBirdBirdsGuessed + score,
    );

    // Calculate stars
    int stars;
    if (total > 0) {
      final pct = score / total;
      if (pct == 1.0) {
        stars = 3;
      } else if (pct >= 0.8) {
        stars = 2;
      } else if (pct >= 0.6) {
        stars = 1;
      } else {
        stars = 0;
      }
    } else {
      stars = 0;
    }

    final String levelId = 'guess_bird_level_$levelIndex';
    final int currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      int newTotalStars = progressStars;
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

    notifyListeners();
  }

  // ─── Speed Challenge ────────────────────────────────────────────────────────

  int get speedChallengeTotalStars {
    int total = 0;
    for (int i = 0; i < 5; i++) {
      total += _levelStars['speed_challenge_level_$i'] ?? 0;
    }
    return total;
  }

  int get speedChallengeMaxStars => 5 * 3;

  int get speedChallengeCompletedLevels => _countSpeedChallengeLevels();

  int _countSpeedChallengeLevels() {
    int count = 0;
    for (int i = 0; i < 5; i++) {
      if ((_levelStars['speed_challenge_level_$i'] ?? 0) > 0) count++;
    }
    return count;
  }

  int get speedChallengeTotalCorrect =>
      _currentProfile?.totalSpeedChallengeCorrect ?? 0;

  void finishSpeedChallengeLevel(int levelIndex, int score, int total) {
    if (_currentProfile == null) return;

    _score = score;
    _wordGameTotalQuestions = total;
    _currentCategory = 'speed_challenge';
    _oldLevelTitle = null;
    _newLevelTitle = null;
    _oldEvolutionStage = null;
    _newEvolutionStage = null;

    _updateCurrentProfile(
      totalSpeedChallengeCorrect:
          _currentProfile!.totalSpeedChallengeCorrect + score,
    );

    int stars;
    if (total > 0) {
      final pct = score / total;
      if (pct == 1.0) {
        stars = 3;
      } else if (pct >= 0.8) {
        stars = 2;
      } else if (pct >= 0.6) {
        stars = 1;
      } else {
        stars = 0;
      }
    } else {
      stars = 0;
    }

    final String levelId = 'speed_challenge_level_$levelIndex';
    final int currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      int newTotalStars = progressStars;
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

    notifyListeners();
  }

  int get crossbirdCompletedPuzzles {
    int count = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('crossbird_puzzle_') && stars > 0) count++;
    });
    return count;
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

  int get rescueTotalStars {
    int total = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('rescue_bird')) total += stars;
    });
    return total;
  }

  int get rescueMaxStars => 3;

  int levelStars(String levelId) => _levelStars[levelId] ?? 0;

  int get rescueCompletedLevels {
    int count = 0;
    _levelStars.forEach((key, stars) {
      if (key.startsWith('rescue_bird') && stars > 0) count++;
    });
    return count;
  }

  int get wordGamesTotalStars =>
      unscrambleTotalStars + rescueTotalStars + crossbirdTotalStars;
  int get wordGamesMaxStars =>
      unscrambleMaxStars + rescueMaxStars + crossbirdMaxStars;

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
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      // Check for Level Up
      int newTotalStars = progressStars;
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

  void saveRescueBirdStars(
    int rescuedCount, {
    int totalPuzzles = 3,
  }) {
    if (_currentProfile == null) return;

    _score = rescuedCount;
    _wordGameTotalQuestions = totalPuzzles;

    int stars = 0;
    if (rescuedCount >= totalPuzzles) {
      stars = 3;
    } else if (rescuedCount >= 2) {
      stars = 2;
    } else if (rescuedCount >= 1) {
      stars = 1;
    }

    const String levelId = 'rescue_bird';
    int currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStars = Map<String, int>.from(_levelStars);
      newStars[levelId] = stars;
      _updateCurrentProfile(levelStars: newStars);

      int newTotalStars = progressStars;
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
  int get totalRescuedBirds => _currentProfile?.totalRescuedBirds ?? 0;

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

  // All stars ever earned, including daily challenge (for raw stat display only).
  int get totalStars {
    int total = 0;
    _levelStars.forEach((_, stars) {
      total += stars;
    });
    return total;
  }

  // Stars that count toward level-up / evolution / maxStars. Excludes daily
  // challenge stars (daily_challenge_* keys) per design.
  int get progressStars {
    int total = 0;
    _levelStars.forEach((key, stars) {
      if (!key.startsWith('daily_challenge_')) total += stars;
    });
    return total;
  }

  int get textQuizTotalStars {
    int total = 0;
    for (var level in _allLevelsGlobally) {
      total += _levelStars[level.id] ?? 0;
    }
    return total;
  }

  int get textQuizMaxStars => _allLevelsGlobally.length * 3; // 80 * 3 = 240

  // Total possible stars across all game modes (excluding daily challenge):
  // Text Quiz 240 + Unscramble 15 + Rescue 3 + Bird ID 90 + Crossbird 12 + Guess the Bird 15 + Speed Challenge 15 = 390
  int get maxStars =>
      textQuizMaxStars +        // 240
      unscrambleMaxStars +      // 15
      rescueMaxStars +          // 3
      birdIdMaxStars +          // 90
      crossbirdMaxStars +       // 12
      guessBirdMaxStars +       // 15
      speedChallengeMaxStars;   // 15 → total 390

  bool get isMaxCompletion => progressStars >= maxStars;

  int get completedLevelsCount {
    int count = 0;
    for (var level in _allLevelsGlobally) {
      if ((_levelStars[level.id] ?? 0) > 0) count++;
    }
    return count;
  }

  String get userStatusTitle => _getStatusTitleForStars(progressStars);

  // 9 levels (0–8). Level 8 "Bird Wizard" reached at 370 stars ≈ 95% of 390.
  // At 100% (390 stars) the title stays "Bird Wizard" but a crown is shown.
  String _getStatusTitleForStars(int starCount) {
    if (starCount < 5) return 'Just Hatched';
    if (starCount < 15) return 'Bird Newbie';
    if (starCount < 35) return 'Feather Weight';
    if (starCount < 65) return 'Learning to Fly';
    if (starCount < 110) return 'Nest Builder';
    if (starCount < 170) return 'Winging It';
    if (starCount < 250) return 'High Flyer';
    if (starCount < 370) return 'Eagle Eye';
    return 'Bird Wizard'; // 370+ stars (≥95%), level 8
  }

  int get userLevelIndex => getLevelIndexForStars(progressStars);

  // Level index 8 = max rank. Evolution formula (levelIndex ~/ 2) + 1 gives:
  // levels 0-1→stage1, 2-3→stage2, 4-5→stage3, 6-7→stage4, 8→stage5
  int getLevelIndexForStars(int starCount) {
    if (starCount < 5) return 0;
    if (starCount < 15) return 1;
    if (starCount < 35) return 2;
    if (starCount < 65) return 3;
    if (starCount < 110) return 4;
    if (starCount < 170) return 5;
    if (starCount < 250) return 6;
    if (starCount < 370) return 7;
    return 8; // Bird Wizard
  }

  int get userEvolutionStage => getEvolutionStageForStars(progressStars);

  int getEvolutionStageForStars(int starCount) {
    return (getLevelIndexForStars(starCount) ~/ 2) + 1;
  }

  double get nextLevelProgress {
    if (isMaxCompletion) return 1.0;
    int current = progressStars;
    int nextThreshold = _getNextLevelThreshold(current);
    int prevThreshold = _getPreviousLevelThreshold(current);
    int range = nextThreshold - prevThreshold;
    int earnedInLevel = current - prevThreshold;
    return earnedInLevel / range;
  }

  int get currentStarsInLevel {
    if (isMaxCompletion) return maxStars;
    int current = progressStars;
    int prevThreshold = _getPreviousLevelThreshold(current);
    return current - prevThreshold;
  }

  int get neededStarsForNextLevel {
    if (isMaxCompletion) return maxStars;
    int current = progressStars;
    int nextThreshold = _getNextLevelThreshold(current);
    int prevThreshold = _getPreviousLevelThreshold(current);
    return nextThreshold - prevThreshold;
  }

  int _getNextLevelThreshold(int starCount) {
    if (starCount < 5) return 5;
    if (starCount < 15) return 15;
    if (starCount < 35) return 35;
    if (starCount < 65) return 65;
    if (starCount < 110) return 110;
    if (starCount < 170) return 170;
    if (starCount < 250) return 250;
    if (starCount < 370) return 370;
    return maxStars; // 390 — king state
  }

  int _getPreviousLevelThreshold(int starCount) {
    if (starCount < 5) return 0;
    if (starCount < 15) return 5;
    if (starCount < 35) return 15;
    if (starCount < 65) return 35;
    if (starCount < 110) return 65;
    if (starCount < 170) return 110;
    if (starCount < 250) return 170;
    if (starCount < 370) return 250;
    return 370; // Max rank entry point
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

  // Endless Mode public getters
  bool get isEndlessMode => _isEndlessMode;
  int get endlessStreak => _endlessStreak;
  int get endlessStrikes => _endlessStrikes;
  int get lastEndlessStreak => _lastEndlessStreak;
  Question get endlessCurrentQuestion {
    if (_endlessCurrentQuestion != null) return _endlessCurrentQuestion!;
    // Fallback to standard currentQuestion if something goes wrong
    return currentQuestion;
  }

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
    if (_isEndlessMode) return false;
    if (_currentLevel == null) return true;
    return _currentQuestionIndex >= _activeQuestions.length;
  }

  Question get currentQuestion {
    if (_isEndlessMode && _endlessCurrentQuestion != null) {
      return _endlessCurrentQuestion!;
    }

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

  // --- Endless Mode Logic ---

  void startEndlessMode() {
    _isEndlessMode = true;
    _endlessStreak = 0;
    _endlessStrikes = 0;
    _endlessQuestionCount = 0;
    _lastEndlessStreak = 0;
    _selectedAnswerIndex = null;
    _isAnswerProcessing = false;
    _currentCategory = 'endless';
    _currentLevel = null;
    _activeQuestions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _wordGameTotalQuestions = null;

    _endlessCurrentQuestion = _generateNextEndlessQuestion();
    notifyListeners();
  }

  Question _generateNextEndlessQuestion() {
    _endlessQuestionCount++;

    // Simple ramp-up: as question count increases, bias towards later levels.
    final allLevels = _allLevelsGlobally;
    if (allLevels.isEmpty) {
      return _allLevelsGlobally.first.questions.first;
    }

    final int totalLevels = allLevels.length;
    final double progress =
        (_endlessQuestionCount / 50).clamp(0.0, 1.0); // 0..1 over 50 Qs

    final int minIndex = (progress * totalLevels * 0.4).toInt().clamp(
          0,
          totalLevels - 1,
        );
    final int maxIndex = (progress * totalLevels).toInt().clamp(
          minIndex,
          totalLevels - 1,
        );

    final int levelIndex =
        minIndex + _random.nextInt((maxIndex - minIndex) + 1);
    final Level level = allLevels[levelIndex];

    if (level.questions.isEmpty) {
      return allLevels.first.questions.first;
    }

    final Question baseQuestion =
        level.questions[_random.nextInt(level.questions.length)];

    final originalCorrectOption = baseQuestion.options[baseQuestion
        .correctOptionIndex];
    final scrambledOptions = List<String>.from(baseQuestion.options)..shuffle();
    final newCorrectIndex = scrambledOptions.indexOf(originalCorrectOption);

    return Question(
      id: baseQuestion.id,
      text: baseQuestion.text,
      imagePath: baseQuestion.imagePath,
      options: scrambledOptions,
      correctOptionIndex: newCorrectIndex,
    );
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
    if (_isEndlessMode) {
      _selectEndlessAnswer(index);
      return;
    }
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

  void _selectEndlessAnswer(int index) {
    if (_isAnswerProcessing || _selectedAnswerIndex != null) return;

    _selectedAnswerIndex = index;
    _isAnswerProcessing = true;

    if (_endlessCurrentQuestion != null &&
        _selectedAnswerIndex == _endlessCurrentQuestion!.correctOptionIndex) {
      _endlessStreak++;

      // Update global totals under a dedicated 'endless' category key
      Map<String, int> newCategoryCorrect = Map<String, int>.from(
        _currentProfile?.categoryCorrectAnswers ?? {},
      );

      const String categoryKey = 'endless';

      newCategoryCorrect[categoryKey] =
          (newCategoryCorrect[categoryKey] ?? 0) + 1;

      _updateCurrentProfile(
        totalCorrectAnswers: totalCorrectAnswers + 1,
        categoryCorrectAnswers: newCategoryCorrect,
      );
    } else {
      _endlessStrikes++;
    }

    notifyListeners();

    Timer(const Duration(seconds: 1), () {
      if (_isEndlessMode || _endlessStrikes >= 3) {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (_isEndlessMode) {
      if (_endlessStrikes >= 3) {
        _finishEndlessRun();
        notifyListeners();
        return;
      }

      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _isAnswerProcessing = false;
      _endlessCurrentQuestion = _generateNextEndlessQuestion();
      notifyListeners();
      return;
    }

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
      if (_currentLevel!.id == 'daily_challenge_level') {
        int stars = (_score == 1) ? 1 : 0;
        final now = DateTime.now();
        int newStreak = _currentProfile!.currentDailyStreak;
        final lastDate = _currentProfile!.lastDailyChallengeDate;

        if (lastDate != null) {
          final difference = DateTime(now.year, now.month, now.day)
              .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
              .inDays;
          if (difference == 1) {
            newStreak++;
          } else if (difference > 1) {
            newStreak = 1;
          }
        } else {
          newStreak = 1;
        }

        String dailyLevelKey =
            'daily_challenge_${now.year}_${now.month}_${now.day}';

        int oldTotalStars = progressStars;
        String oldTitle = _getStatusTitleForStars(oldTotalStars);
        int oldEvo = getEvolutionStageForStars(oldTotalStars);

        final newStars = Map<String, int>.from(_levelStars);
        if (stars > 0) newStars[dailyLevelKey] = stars;

        _updateCurrentProfile(
          lastDailyChallengeDate: now,
          currentDailyStreak: newStreak,
          totalDailyChallengesCompleted:
              _currentProfile!.totalDailyChallengesCompleted + 1,
          levelStars: newStars,
        );

        int newTotalStars = progressStars;
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
        return;
      }

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
        int oldTotalStars = progressStars;
        String oldTitle = _getStatusTitleForStars(oldTotalStars);
        int oldEvo = getEvolutionStageForStars(oldTotalStars);

        // Update stars
        // Create new copy of map
        final newStars = Map<String, int>.from(_levelStars);
        newStars[_currentLevel!.id] = stars;
        _updateCurrentProfile(levelStars: newStars);

        // Check for Level Up
        // We need to fetch totalStars again as it's a computed property based on the updated profile
        int newTotalStars = progressStars;
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
    _isEndlessMode = false;
    _endlessStreak = 0;
    _endlessStrikes = 0;
    _endlessQuestionCount = 0;
    _endlessCurrentQuestion = null;
    _lastEndlessStreak = 0;
    notifyListeners();
  }

  void _finishEndlessRun() {
    _lastEndlessStreak = _endlessStreak;

    final int previousHigh = endlessHighScore;
    updateEndlessHighScore(_endlessStreak);
    final int newHigh = endlessHighScore;

    // Map best endless streak to stars
    int starsForStreak(int streak) {
      if (streak >= 50) return 3;
      if (streak >= 20) return 2;
      if (streak >= 10) return 1;
      return 0;
    }

    final String levelId = 'endless_mode';
    final int previousStars = _levelStars[levelId] ?? 0;
    final int previousBestStars = starsForStreak(previousHigh);
    final int newBestStars = starsForStreak(newHigh);

    int effectiveOldStars = previousStars > previousBestStars
        ? previousStars
        : previousBestStars;
    int effectiveNewStars = newBestStars;

    if (effectiveNewStars > effectiveOldStars) {
      int oldTotalStars = progressStars;
      String oldTitle = _getStatusTitleForStars(oldTotalStars);
      int oldEvo = getEvolutionStageForStars(oldTotalStars);

      final newStarsMap = Map<String, int>.from(_levelStars);
      newStarsMap[levelId] = effectiveNewStars;
      _updateCurrentProfile(levelStars: newStarsMap);

      int newTotalStars = progressStars;
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

    _isEndlessMode = false;
    _selectedAnswerIndex = null;
    _isAnswerProcessing = false;
  }
}

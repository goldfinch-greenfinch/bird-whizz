class UserProfile {
  final String id;
  final String name;
  final String companionBirdId;
  final Map<String, int> levelStars;
  final int totalCorrectAnswers;
  final Map<String, int> categoryCorrectAnswers;
  final int birdIdHighScore; // New field for Bird ID Quiz High Score
  final Map<String, int>
  wordGameHighScores; // New field for Word Games High Scores
  final DateTime? firstPlayDate;
  final int totalTimePlayingSeconds;
  final int totalUnscrambledWords;
  final List<String> unlockedStamps; // List of unlocked stamp IDs

  // Word game specific stats
  final int totalRescuedBirds;
  final int totalCrosswordsSolved;

  // Guess the Bird game stats
  final int totalGuessBirdBirdsGuessed;

  // Speed Challenge game stats
  final int totalSpeedChallengeCorrect;

  // Daily Challenge & Login Tracking
  final DateTime? lastDailyChallengeDate;
  final int currentDailyStreak;
  final int totalDailyChallengesCompleted;
  final DateTime? lastLoginDate;
  final int currentLoginStreak;

  UserProfile({
    required this.id,
    required this.name,
    required this.companionBirdId,
    this.levelStars = const {},
    this.totalCorrectAnswers = 0,
    this.categoryCorrectAnswers = const <String, int>{},
    this.birdIdHighScore = 0,
    this.wordGameHighScores = const <String, int>{},
    this.firstPlayDate,
    this.totalTimePlayingSeconds = 0,
    this.totalUnscrambledWords = 0,
    this.unlockedStamps = const [],
    this.lastDailyChallengeDate,
    this.currentDailyStreak = 0,
    this.totalDailyChallengesCompleted = 0,
    this.lastLoginDate,
    this.currentLoginStreak = 0,
    this.totalRescuedBirds = 0,
    this.totalCrosswordsSolved = 0,
    this.totalGuessBirdBirdsGuessed = 0,
    this.totalSpeedChallengeCorrect = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companionBirdId': companionBirdId,
      'levelStars': levelStars,
      'totalCorrectAnswers': totalCorrectAnswers,
      'categoryCorrectAnswers': categoryCorrectAnswers,
      'birdIdHighScore': birdIdHighScore,
      'wordGameHighScores': wordGameHighScores,
      'firstPlayDate': firstPlayDate?.toIso8601String(),
      'totalTimePlayingSeconds': totalTimePlayingSeconds,
      'totalUnscrambledWords': totalUnscrambledWords,
      'unlockedStamps': unlockedStamps,
      'lastDailyChallengeDate': lastDailyChallengeDate?.toIso8601String(),
      'currentDailyStreak': currentDailyStreak,
      'totalDailyChallengesCompleted': totalDailyChallengesCompleted,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'currentLoginStreak': currentLoginStreak,
      'totalRescuedBirds': totalRescuedBirds,
      'totalCrosswordsSolved': totalCrosswordsSolved,
      'totalGuessBirdBirdsGuessed': totalGuessBirdBirdsGuessed,
      'totalSpeedChallengeCorrect': totalSpeedChallengeCorrect,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      companionBirdId: json['companionBirdId'] as String,
      levelStars:
          (json['levelStars'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const <String, int>{},
      totalCorrectAnswers: json['totalCorrectAnswers'] as int? ?? 0,
      categoryCorrectAnswers:
          (json['categoryCorrectAnswers'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const <String, int>{},
      birdIdHighScore: json['birdIdHighScore'] as int? ?? 0,
      wordGameHighScores:
          (json['wordGameHighScores'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const <String, int>{},
      firstPlayDate: json['firstPlayDate'] != null
          ? DateTime.tryParse(json['firstPlayDate'] as String)
          : null,
      totalTimePlayingSeconds: json['totalTimePlayingSeconds'] as int? ?? 0,
      totalUnscrambledWords: json['totalUnscrambledWords'] as int? ?? 0,
      unlockedStamps:
          (json['unlockedStamps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      lastDailyChallengeDate: json['lastDailyChallengeDate'] != null
          ? DateTime.tryParse(json['lastDailyChallengeDate'] as String)
          : null,
      currentDailyStreak: json['currentDailyStreak'] as int? ?? 0,
      totalDailyChallengesCompleted:
          json['totalDailyChallengesCompleted'] as int? ?? 0,
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.tryParse(json['lastLoginDate'] as String)
          : null,
      currentLoginStreak: json['currentLoginStreak'] as int? ?? 0,
      totalRescuedBirds: json['totalRescuedBirds'] as int? ?? 0,
      totalCrosswordsSolved: json['totalCrosswordsSolved'] as int? ?? 0,
      totalGuessBirdBirdsGuessed: json['totalGuessBirdBirdsGuessed'] as int? ?? 0,
      totalSpeedChallengeCorrect: json['totalSpeedChallengeCorrect'] as int? ?? 0,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? companionBirdId,
    Map<String, int>? levelStars,
    int? totalCorrectAnswers,
    Map<String, int>? categoryCorrectAnswers,
    int? birdIdHighScore,
    Map<String, int>? wordGameHighScores,
    DateTime? firstPlayDate,
    int? totalTimePlayingSeconds,
    int? totalUnscrambledWords,
    List<String>? unlockedStamps,
    DateTime? lastDailyChallengeDate,
    int? currentDailyStreak,
    int? totalDailyChallengesCompleted,
    DateTime? lastLoginDate,
    int? currentLoginStreak,
    int? totalRescuedBirds,
    int? totalCrosswordsSolved,
    int? totalGuessBirdBirdsGuessed,
    int? totalSpeedChallengeCorrect,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      companionBirdId: companionBirdId ?? this.companionBirdId,
      levelStars: levelStars ?? this.levelStars,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      categoryCorrectAnswers:
          categoryCorrectAnswers ?? this.categoryCorrectAnswers,
      birdIdHighScore: birdIdHighScore ?? this.birdIdHighScore,
      wordGameHighScores: wordGameHighScores ?? this.wordGameHighScores,
      firstPlayDate: firstPlayDate ?? this.firstPlayDate,
      totalTimePlayingSeconds:
          totalTimePlayingSeconds ?? this.totalTimePlayingSeconds,
      totalUnscrambledWords:
          totalUnscrambledWords ?? this.totalUnscrambledWords,
      unlockedStamps: unlockedStamps ?? this.unlockedStamps,
      lastDailyChallengeDate:
          lastDailyChallengeDate ?? this.lastDailyChallengeDate,
      currentDailyStreak: currentDailyStreak ?? this.currentDailyStreak,
      totalDailyChallengesCompleted:
          totalDailyChallengesCompleted ?? this.totalDailyChallengesCompleted,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      currentLoginStreak: currentLoginStreak ?? this.currentLoginStreak,
      totalRescuedBirds: totalRescuedBirds ?? this.totalRescuedBirds,
      totalCrosswordsSolved:
          totalCrosswordsSolved ?? this.totalCrosswordsSolved,
      totalGuessBirdBirdsGuessed:
          totalGuessBirdBirdsGuessed ?? this.totalGuessBirdBirdsGuessed,
      totalSpeedChallengeCorrect:
          totalSpeedChallengeCorrect ?? this.totalSpeedChallengeCorrect,
    );
  }
}

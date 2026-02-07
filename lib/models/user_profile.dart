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

  UserProfile({
    required this.id,
    required this.name,
    required this.companionBirdId,
    this.levelStars = const {},
    this.totalCorrectAnswers = 0,
    this.categoryCorrectAnswers = const <String, int>{},
    this.birdIdHighScore = 0,
    this.wordGameHighScores = const <String, int>{},
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
    );
  }
}

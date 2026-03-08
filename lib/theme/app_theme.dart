import 'package:flutter/material.dart';

/// Central color palette for Bird Whizz.
abstract final class AppColors {
  // ── Primary (teal) ──────────────────────────────────────────────────────
  static const Color primary          = Color(0xFF009688); // Colors.teal
  static const Color primaryLight     = Color(0xFFE0F2F1); // teal[50]
  static const Color primaryMid       = Color(0xFF00897B); // teal[700]
  static const Color primaryDark      = Color(0xFF00695C); // teal[800]
  static const Color primaryDeep      = Color(0xFF004D40); // teal[900]
  static const Color onPrimary        = Colors.white;

  // ── Game-mode accents ───────────────────────────────────────────────────
  static const Color speedChallenge           = Color(0xFFE65100); // deep orange
  static const Color speedChallengeBackground = Color(0xFFFFF3E0);
  static const Color guessBird                = Color(0xFF3F51B5); // indigo
  static const Color wordGames                = Color(0xFF7C4DFF); // deepPurpleAccent
  static const Color birdId                   = Color(0xFFFF6D00); // orangeAccent.shade700
  static const Color crossword                = Color(0xFF1B5E20); // dark green
  static const Color crosswordBackground      = Color(0xFFF0F8F0);

  // ── Semantic ────────────────────────────────────────────────────────────
  static const Color success  = Color(0xFF4CAF50); // green
  static const Color error    = Color(0xFFF44336); // red
  static const Color star     = Color(0xFFFFC107); // amber
  static const Color warning  = Color(0xFFFF9800); // orange

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color questionText = Color(0xFF2C3E50);

  // ── Endless mode gradient ───────────────────────────────────────────────
  static const Color endlessGradientStart = Color(0xFF26A69A);
  static const Color endlessGradientEnd   = Color(0xFF004D40);

  // ── Stamp / achievements ────────────────────────────────────────────────
  static const Color stampPaper  = Color(0xFFF7F2E2);
  static const Color stampBrown  = Color(0xFF4E342E); // brown[800]
  static const Color stampDark   = Color(0xFF3E2723); // brown[900]
}

/// Named text styles for Bird Whizz.
abstract final class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xDD000000), // black87
  );

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.4,
    color: AppColors.primary,
  );

  static const TextStyle bodyCaption = TextStyle(
    fontSize: 13,
    height: 1.5,
    color: Color(0xDD000000),
  );

  static const TextStyle labelBadge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle statValue = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle statLabel = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 10,
  );
}

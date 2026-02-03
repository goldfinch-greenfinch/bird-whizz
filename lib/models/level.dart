import 'package:flutter/material.dart';
import 'question.dart';

class Level {
  final String id;
  final String name;
  final List<Question> questions;
  final int requiredScoreToUnlock;
  final IconData iconData;

  Level({
    required this.id,
    required this.name,
    required this.questions,
    this.requiredScoreToUnlock = 0,
    this.iconData = Icons.star, // Default
  });
}

import 'package:flutter/material.dart';

/// Returns the medal color for [stars] out of [maxStars].
/// Bronze at ≥ 1/3, Silver at ≥ 2/3, Gold at == max.
/// Returns null if 0 stars.
Color? medalColor(int stars, [int maxStars = 3]) {
  if (stars <= 0 || maxStars <= 0) return null;
  final ratio = stars / maxStars;
  if (ratio >= 1.0) return const Color(0xFFFFB300); // gold
  if (ratio >= 2 / 3) return const Color(0xFF9E9E9E); // silver
  return const Color(0xFFCD7F32); // bronze
}

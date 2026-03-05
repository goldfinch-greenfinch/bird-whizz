class DailyQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;

  const DailyQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}

class Question {
  final String id;
  final String text;
  final String? imagePath;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.id,
    required this.text,
    this.imagePath,
    required this.options,
    required this.correctOptionIndex,
  });
}
